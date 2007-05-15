Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbXEOIIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbXEOIIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXEOIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:08:10 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46116 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbXEOIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:08:08 -0400
Date: Tue, 15 May 2007 10:05:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
In-Reply-To: <4648E0AE.6010709@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0705151005330.9570@yvahk01.tjqt.qr>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl>
 <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr>
 <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr>
 <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr>
 <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
 <4648E0AE.6010709@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 00:20, Stefan Richter wrote:
>
>You forgot this in the plain-text part of your mail:

Well thanks for pasting :)

>
>[quote]
>
>  * Convert files to UTF-8.
>
>  * Also correct some people's names
>    (one example is Eißfeldt, which was found in a source file.
>    Given that the author used an ß at all in a source file
>    indicates that the real name has in fact a 'ß' and not an 'ss',
>    which is commonly used as a substitute for 'ß' when limited to
>    7bit.)
>
>  * Correct town names (Goettingen -> Göttingen)
>
>  * Update Eberhard Mönkeberg's address (http://lkml.org/lkml/2007/1/8/313)
>
>[...]

	Jan
-- 
