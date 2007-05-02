Return-Path: <linux-kernel-owner+w=401wt.eu-S1767164AbXEBWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767164AbXEBWwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767165AbXEBWwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:52:21 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45032 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767164AbXEBWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:52:20 -0400
Message-ID: <46391590.8080209@gmail.com>
Date: Thu, 03 May 2007 00:49:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com> <4638FDA6.9030500@gmail.com> <4638FF70.8020400@zytor.com> <46390086.2030904@gmail.com> <463901C9.7090107@zytor.com> <46390503.1000401@gmail.com> <46390CA3.5030300@zytor.com>
In-Reply-To: <46390CA3.5030300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2007 12:11 AM, H. Peter Anvin wrote:

> The problem is to detect the ones that have it from the ones that don't.

Checking here, and mine also has 132x25 as BIOS mode 0x14 in addition to 
0x55. Probably also not universal, and 0x54 (132x43) doesn't seem to be 
repeated. Unfortunate that Qemu/Bocks don't have the VESA text modes.

Rene.

