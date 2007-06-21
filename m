Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXFUNmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXFUNmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXFUNmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:42:10 -0400
Received: from [212.12.190.78] ([212.12.190.78]:32915 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbXFUNmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:42:09 -0400
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: How to improve the quality of the kernel?
Date: Thu, 21 Jun 2007 16:41:28 +0300
User-Agent: KMail/1.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200706180141.41101.a1426z@gawab.com> <200706210626.20429.a1426z@gawab.com> <20070621130737.GN12950@stusta.de>
In-Reply-To: <20070621130737.GN12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211641.28504.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jun 21, 2007 at 06:26:20AM +0300, Al Boldi wrote:
> > Adrian Bunk wrote:
> > > We are talking about _tracking_.
> > >
> > > I'm not sure whether it makes much sense, and it would cost an
> > > enormous amount of time, but tracking patches should be possible
> > > without any knowledge of the kernel.
> >
> > If that's really true, which I can't imagine, then the proper way
> > forward would probably involve a fully automated system.
>
> If you consider any kind of patch tracking valuable, you should either
> do it yourself or write the tool yourself. In both cases, the
> interesting parts would be how to integrate it into the workflow of
> kernel development without creating extra work for anyone and how to get
> the information into the got commits.

Integration is the easy part, really.  Just filter all the patches from the 
mailing list into a patch-bin, then sort, categorize, and prioritize them, 
responding with a validation status to all parties involved.

And after that comes the Tracking part.

> "requires a real PRO" and "would probably involve" sound like cheap
> phrases for avoiding doing any work yourself.

I have learned from this list that premature involvement is 
counterproductive.

> Talk is cheap, but unless YOU will do it your emails will only be a
> waste of bandwidth.

Thanks, and good luck with involving people with this kind of response!

--
Al

