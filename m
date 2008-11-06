Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKFVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKFVZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYKFVYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:24:52 -0500
Received: from bu3sch.de ([62.75.166.246]:37967 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYKFVYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:24:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] SSB: make it depend on PCI
Date: Thu, 6 Nov 2008 22:24:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Mike Frysinger" <vapier@gentoo.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225965082-31462-1-git-send-email-vapier@gentoo.org> <200811061759.29319.mb@bu3sch.de> <8bd0f97a0811061314x53e871c8rc9a7de4c4c10f359@mail.gmail.com>
In-Reply-To: <8bd0f97a0811061314x53e871c8rc9a7de4c4c10f359@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811062224.26698.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 22:14:30 Mike Frysinger wrote:
> On Thu, Nov 6, 2008 at 11:59, Michael Buesch wrote:
> > On Thursday 06 November 2008 12:32:50 Mike Frysinger wrote:
> >> OK.  regarding the patch, if we drop the "&& PCI" part, i think the
> >> rest should get merged ... having empty menus in kconfig is annoying.
> >> agreed ?
> >
> > We have these all over the place.
> 
> that's a weak argument.  empty menus should go away, not remain
> "because other people are doing it too".  with that mentality, there's
> many issues we wouldnt be able to address.

Well, I don't see this as an issue, as 99.9% of the people don't hit that
case and if they do it doesn't matter anyway.
But hey, if you want to apply this, feel free to do so.

-- 
Greetings Michael.
