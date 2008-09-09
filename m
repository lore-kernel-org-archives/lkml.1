Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYIISi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYIISi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYIISiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:38:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52063 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbYIISiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:38:20 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Date: Tue, 9 Sep 2008 14:34:59 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Janne Grunau <j@jannau.net>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809091123.57109.jwilson@redhat.com> <20080909182710.GA31271@csclub.uwaterloo.ca>
In-Reply-To: <20080909182710.GA31271@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091434.59647.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 14:27:10 Lennart Sorensen wrote:
> On Tue, Sep 09, 2008 at 11:23:56AM -0400, Jarod Wilson wrote:
> > I meant to include that the ordering of the patches was more or less from
> > most-used/most-tested to least-used/least-tested, and a few of the
> > patches do include Tested-by: lines in them. Basically, the first four or
> > five drivers probably cover the majority of users, so getting them in
> > first would provide the most bang-for-your-buck. But I can certainly
> > re-send with only the tested drivers after we get through the first round
> > of comments, if that's preferred over my approach of putting the
> > higher-prio ones to the front of the ordering.
>
> The soundgraph imon driver is number 8, but it works great for me, and lots
> of cases include that one (at least silverstone cases).  I think more
> than the first 4 or 5 are in very active use.

Yeah, I realized imon was much lower in the sort order after my reply there, 
which was a bad initial move by me, since its actually one of the ones that 
has definite positive testing feedback already. I believe quite a number of 
vendors of HTPC cases use imon lcd (or vfd) and ir combo devices.

-- 
Jarod Wilson
jarod@redhat.com

