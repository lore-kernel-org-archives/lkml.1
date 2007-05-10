Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbXEJJ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbXEJJ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXEJJ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:56:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53317 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbXEJJ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:56:24 -0400
Date: Thu, 10 May 2007 11:54:11 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Adrian Bunk <bunk@stusta.de>, John Anthony Kazos Jr <jakj@j-a-k-j.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: include files: convert "include" subdirectory to UTF-8
In-Reply-To: <Pine.LNX.4.64.0705101047550.14358@anakin>
Message-ID: <Pine.LNX.4.61.0705101153430.32349@yvahk01.tjqt.qr>
References: <200705092102.l49L2axT029607@hera.kernel.org>
 <Pine.LNX.4.64.0705100921230.13222@anakin> <20070510081845.GJ23574@stusta.de>
 <Pine.LNX.4.64.0705101047550.14358@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 10:48, Geert Uytterhoeven wrote:
>> > >  **
>> > > -** Copyright 1994 by Bj?rn Brauel
>> > > +** Copyright 1994 by Bjrn Brauel
>> > >  **
>> > >  ** 5/2/94 Roman Hodek:
>> > >  **   TT interrupt definitions added.
>> > 
>> > These two seem to have failed.
>> 
>> They changed from wrong and invalid UTF-8 to wrong and valid UTF-8.
>> 
>> I saw this when applying the patch, but I wasn't sure which character 
>> would be correct in this name.
>
>I checked a very old source tree and a few encodings. In IBM850 it's an
>o-umlaut, which is what I expected in the first place.

Make sure it does not accidentally map to a ø in some charsets :p


	Jan
-- 
