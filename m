Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbZCZROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbZCZROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZCZROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:14:11 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:50113 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbZCZROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:14:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Jose Celestino <japc@co.sapo.pt>
Subject: Re: relatime: update once per day patches (was: ext3 IO latency measurements)
Date: Thu, 26 Mar 2009 18:14:02 +0100
User-Agent: KMail/1.9.9
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, jack@suse.cz,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
References: <20090325235041.GA11024@duck.suse.cz> <20090326163026.GD6239@mit.edu> <20090326164053.GA6318@co.sapo.pt>
In-Reply-To: <20090326164053.GA6318@co.sapo.pt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261814.07375.elendil@planet.nl>
X-OriginalArrivalTime: 26 Mar 2009 17:14:07.0837 (UTC) FILETIME=[45BED0D0:01C9AE36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009, Jose Celestino wrote:
> Words by Theodore Tso [Thu, Mar 26, 2009 at 12:30:26PM -0400]:
> > On Thu, Mar 26, 2009 at 09:14:28AM -0700, Linus Torvalds wrote:
> > > I generally agree witht he "leave policy to user space" people, but
> > > this is an area where (a) user space has shown itself to not get it
> > > right (ie people don't do even the existing relatime because
> > > distros don't) and (b) what's the alternative?
> >
> > I thought at least some distro's were adding relatime by default; I
> > could be wrong, but I thought Ubuntu was doing this.
>
> Yes.

No, not the "pure" relatime that's in the upstream kernel. And that's the 
whole point here. See my direct reply to Ted.

Cheers,
FJP
