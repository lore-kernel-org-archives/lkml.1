Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbXBOAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbXBOAGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXBOAGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:06:44 -0500
Received: from khc.piap.pl ([195.187.100.11]:44568 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbXBOAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:06:43 -0500
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dax Kelson <dax@gurulabs.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
	<20070214202144.1ddb930f.khali@linux-fr.org>
	<Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
	<1171488840.3706.78.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.61.0702142257490.19368@yvahk01.tjqt.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 15 Feb 2007 01:06:40 +0100
In-Reply-To: <Pine.LNX.4.61.0702142257490.19368@yvahk01.tjqt.qr> (Jan Engelhardt's message of "Wed, 14 Feb 2007 22:58:42 +0100 (MET)")
Message-ID: <m34ppojncf.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

>>I checked, and looking at offset 0x497 seems to work fine on a couple of
>>systems with USB keyboards.
>
> Probably just because legacy mode was enabled. Plus I wonder what 0x497 will
> return when there is actually more than one USB keyboard connected at boot.

I bet all would share LED states. If you can use multiple keyboards
in legacy mode at all, of course.
-- 
Krzysztof Halasa
