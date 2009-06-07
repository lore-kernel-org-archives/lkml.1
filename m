Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZFGOju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZFGOju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZFGOjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:39:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38264 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbZFGOjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:39:42 -0400
Date: Sun, 7 Jun 2009 15:40:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
Message-ID: <20090607154048.07a7fb65@lxorguk.ukuu.org.uk>
In-Reply-To: <200906071632.30914.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	<20090607152151.3cb01901@lxorguk.ukuu.org.uk>
	<200906071632.30914.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want to discuss any code that I push upstream then *please* quote
> it in your mails so we all can see what parts you question and discuss it
> based on technical merits.

This isn't about technical merits - it is about *risk*. You don't submit
patches to core code to add new features just before the final release.

And my email included enough meta-information (such as the patch header)
to make the neccessary point.

Alan
