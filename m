Return-Path: <linux-kernel-owner+w=401wt.eu-S970635AbXILRJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970635AbXILRJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764811AbXILRIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:08:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41933 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764893AbXILRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:08:48 -0400
Subject: Re: 2.6.23-rc6: known regressions with patches
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <gregkh@suse.de>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       netdev@vger.kernel.org, Christian Kujau <lists@nerdbynature.de>,
       jamal <hadi@cyberus.ca>, linux-usb-devel@lists.sourceforge.net,
       sean@mess.org, Adrian Bunk <bunk@kernel.org>
In-Reply-To: <46E81AE2.8030802@googlemail.com>
References: <46E81AE2.8030802@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Sep 2007 19:08:25 +0200
Message-Id: <1189616905.3570.59.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 18:59 +0200, Michal Piotrowski wrote:
> MTD
> 
> Subject         : include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
> References      : http://lkml.org/lkml/2007/9/11/151
> Last known good : ?
> Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> Caused-By       : ?
> Handled-By      : ?
> Patch           : http://git.infradead.org/?p=mtd-2.6.git;a=commit;h=241651d04d672fb685b2874707016cbbf95931e5
> Status          : patch available

Didn't you already _drop_ this from your list of regressions once?

-- 
dwmw2

