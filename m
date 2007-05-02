Return-Path: <linux-kernel-owner+w=401wt.eu-S1767140AbXEBSZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767140AbXEBSZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767143AbXEBSZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:25:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35776 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767140AbXEBSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:25:21 -0400
Date: Wed, 2 May 2007 20:25:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Vlad <vladc6@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
In-Reply-To: <741290.4122.qm@web54405.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0705022022590.18504@yvahk01.tjqt.qr>
References: <741290.4122.qm@web54405.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 15:41, Vlad wrote:
>H. Peter Anvin wrote:
>> I'm rewriting the i386 setup code in C, instead of assembly,
>> and before I spend a very large amount of time translating
>> all the various card-specific probes, I want to ask the
>> following question...
>>
>> Does *anyone* care about these anymore?
>
>Yes, booting Linux on old i386/i486 hardware is still very useful for
>forensic purposes and recovering important data.

Not only that, but there's tons of fun involved. I mean, when was the
last time you ran a *recent* kernel from the 2006/2007 era on an
original i386 from 1990 with 3 bogomips? :) (Though I guess these
boxes don't have any 'modern' video besides 640x480x16 or 320x200x256
anyway.)

Jan
-- 
