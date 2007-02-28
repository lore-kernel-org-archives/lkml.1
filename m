Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbXB1QYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbXB1QYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXB1QYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:24:36 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:53091 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbXB1QYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:24:35 -0500
X-Greylist: delayed 129332 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 11:24:35 EST
Message-ID: <45E5ACBC.2050800@blueyonder.co.uk>
Date: Wed, 28 Feb 2007 16:24:28 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >>/ openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to/
 >>/ require a password to unlock, but it asks for password. When the 
screen/
 >>/ unlocks, kwin is gone with no errors logged in /var/log/kdm or/
 >>/ /var/log/messages. No problems with 2.6.20./
 >>
 >>/ Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2./
 >>/ Regards/
 >>/ Sid./

 > This is the linux kernel mailing list. Perhaps you should post your 
problem to
 > the opensuse mailing list.
 >
 > Regards
That's very much appreciated. The point is that all vanilla kernels up 
to 2.6.20+ have not had the problems now seen on 2.6.20-rc1 and 
2.6.20-rc2 and like other problems reported, sic framebuffer, etc., 
there is a distinct likelihood that it's related to those kernels and 
worth reporting here where it will also be seen by the openSUSE kernel 
developers.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


