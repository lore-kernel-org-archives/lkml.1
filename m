Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXEPHAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXEPHAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbXEPG75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:59:57 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57971 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbXEPG75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:59:57 -0400
Date: Wed, 16 May 2007 08:55:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pekka Pietikainen <pp@ee.oulu.fi>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Pekka Pietikainen goes UTF-8
In-Reply-To: <464A9F2E.5020801@zytor.com>
Message-ID: <Pine.LNX.4.61.0705160855270.9570@yvahk01.tjqt.qr>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl>
 <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr>
 <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr>
 <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr>
 <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
 <20070515162314.GA10965@ee.oulu.fi> <464A9F2E.5020801@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 23:05, H. Peter Anvin wrote:
>Pekka Pietikainen wrote:
>> Since everyone else is doing it, why not me as well. Looks like I had
>> a nice retro 7-bit a-umlaut in the tree from ten years ago too! 
>> (That was back when ISO 8859-1 didn't work universally...).
>> I hope my mailer is setup correctly for this, 
>> http://www.ee.oulu.fi/~pp/pp-goes-utf8.patch has the same in 
>> case something in the middle munges up the utf-8.
>
>Your message came through tagged as iso-8859-1.

Which perhaps is best, because UTF-8 is 'valid' ISO-8859-1 afaict,
while the reverse is not true.


	Jan
-- 
