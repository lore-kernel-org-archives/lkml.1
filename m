Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbYBZARA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYBZARA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYBZAQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:16:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYBZAQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:16:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after 2.6.25-rc1 (bisected, powerpc related?)
Date: Tue, 26 Feb 2008 01:13:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: xfs-masters@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gaudenz Steinlin <gaudenz@soziologie.ch>
References: <20080225112310.GA5516@soziologie.ch> <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de>
In-Reply-To: <20080225235703.GA17530@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260113.57875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Christoph Hellwig wrote:
> On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
> > > I'm not suggesting a partial revert; I just wonder which part of the
> > > change is causing the problem, as part of the debugging process.
> > 
> > Understood.
> > 
> > My point is, if that's not practical (whatever the reason), I'd consider
> > reverting all of the commits in question.
> 
> If you could revert all of them and verify it makes the problem go away
> that would be a very good start already.

The original reporter (CC added) said exactly that, if I understood him
correctly:

http://lkml.org/lkml/2008/2/25/123

Thanks,
Rafael
