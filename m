Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXLFS14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXLFS14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXLFS1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:27:48 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:46313 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXLFS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:27:47 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Thu, 6 Dec 2007 19:27:26 +0100
User-Agent: KMail/1.9.7
References: <200712061906.42070.M4rkusXXL@web.de>
In-Reply-To: <200712061906.42070.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061927.35976.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/EGXQYmZd4aBfvqmgL+iqS+Oqp8Y+Z+bbMYnBJ
	Z6dWAKvuXjOiJN0S+XP5zmDMWY/Bz56rUP0GuC1SGwXZ3E27Wv
	32DQJOfOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just forgot to mention:
dmesg gives nothing (/var/log/messages)
the global X log aswell

and in the users .xsession-errors I have:
amarokapp: Fatal IO error: client killed
kdesktop: Fatal IO error: client killed
konqueror: Fatal IO error: client killed
The application 'xchat' lost its connection to the display :0.0;

I dont know what that means, but at least its something ;)

Markus

> Hello!
> 
> Excuse my bad english, I am no native speaker. And please CC me, as I 
am 
> not subscribed!
> 
> I am running an amd64 system with a stable gentoo. Today I upgraded to 
> the kernel 2.6.22 and noticed many programs to disappear.
> I use a kde desktop (3.5.7) and when amarok or kmail crash, normaly 
> a "kde-crash-manager" pops up (but that happend very rarely), but not 
> with 2.6.22+. It happens often and without any messagebox.
> kdesktop, xchat, kicker, konqueror crashed as well.
> It happens more often under heavy load. But it can also happen when 
> idle. Also I have the feeling that it happens more often on 2.6.23+ I 
> might be wrong.
> 
> I tried 2.6.23 and the current 2.6.24-rc4, which all show this problem 
> aswell!
> What has changed in 2.6.21 -> 2.6.22 that could cause such things?
> Or who can tell that?
> Can I help? How? (I use linux for years and can code, but I never 
> debugged anything as big as the kernel...)
> 
> 
> Markus
> 
> PS: Sorry thats so late, but I normaly stay on the distros stable 
kernel 
> and only try vanilla when something is wrong ;)
> 


