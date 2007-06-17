Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbXFQTPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbXFQTPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761183AbXFQTKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:37731 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761239AbXFQTKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:48 -0400
X-Authenticated: #4283818
X-Provags-ID: V01U2FsdGVkX1/GTBYQDWnGzFppchWYTmRNZ3v1Z6KcO4kQXXIXc8
	zYKAcWoiHyEFxN
From: Wolfgang Schnitker <wolfgang.schnitker@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>, akpm@osdl.org
Subject: Re: [Bug 8645] disconnect usb end-device; reading error
Date: Sun, 17 Jun 2007 21:10:39 +0200
User-Agent: KMail/1.9.5
References: <20070617163417.28AF91080F9@picon.linux-foundation.org>
In-Reply-To: <20070617163417.28AF91080F9@picon.linux-foundation.org>
X-Face: #K{nHa"UEZhQ&[QL)`u8IPW%::V-EzK({kZA+<3c/3@2BP\M*RpQ}RbXBrO7bvp(=?utf-8?q?Ef=7B=26=7B=26=0A=09?=>Ve.H8>6XiuC=-qKg<VPu"L>_Dehhp<=?utf-8?q?X=3Dx=3BY3=3FP=5EE=26=7DBk=5BOehDwr*-uc1yw=7B0XRx=60nI=26eS=0A=09?=
 =?utf-8?q?yvx=5C=3FIMpD?=(\X`j[iUi]N$x6PQU?i)@ov.H`|6k9RsX9^~,]5w_ab)8<
 =?utf-8?q?=3FpY=3F=26TV=3BK=24=7EiN=3F5=0A=09=25J-=7CG=3Fsqf=2E0?=
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706172110.40398.wolfgang.schnitker@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Developers,

1.) I have tried it with all recently available debian kernels from 
backports.org. It is the same game playing around. 

2.) I have actualy no other device connected to the hub. It is connected to a 
external power supply and this supply is working properly. I do not think 
that a card reader is consuming more power than a a usb port can give. 

So my opinion stays clear, but if you want to have more information and 
confirmation, please contact those who have (or had) the same problem as 
shown in various internet sites or forums.

My guess is, that ehci does not fall back to usb 1.1 support. Maybe that this 
is a follow up to to hubs not working the way, they should. But I  think that 
is not the linux way to accept it, like w*******s  does. That's why I'm using 
linux.

Chears

Wolfgang


On Sunday 17 June 2007 18:34, you wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=8645
>
>
> akpm@osdl.org changed:
>
>            What    |Removed                     |Added
> ---------------------------------------------------------------------------
>- CC|                            |akpm@osdl.org
>
>
>
>
> ------- Comment #1 from akpm@osdl.org  2007-06-17 09:37 -------
> 2.6.18 is a little old.  Is it repeatable on later kernels?  Ideally
> 2.6.22-rc5?
>
> Thanks.

-- 
Wolfgang Schnitker
