Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZCZRdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZCZRdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZCZRdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:33:38 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45538 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZCZRdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mydJrtxLxtviy7/ZQbeNEZbGAGLYDH9SkbLDHqNTBZ7AF6KHN1SLqhUGS29tZ0GVdK
         W+bYXXM17XTTZ//g32FzNsaEYao29XkhwljLq7ollmwgxGj+9Jah0ba4dIEq87mt//Ws
         O4Bo9WFvflY0XnCw04V3QELumgdJ3Qmgk7gmQ=
Message-ID: <49CBBD78.70200@gmail.com>
Date: Thu, 26 Mar 2009 22:38:00 +0500
From: "Sergey I. Sharybin" <g.ulairi@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Backlight brightness on linux kernel 2.6.28
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using Debian GNU/Linux (Lenny) on my notebook (model HP 6720s) and 
since linux kernel version 2.6.28 there is a trouble with backlight 
brightness: after notebook has been just booted brightess is easily 
controlled by hotkeys, but if the external power state is changed 
(plugged or unplugged) there is no more way to control the brightess of 
backlight until the system reboot. There is the same trouble under 
kernel version 2.6.29. And there is no such problems with kernel version 
<= 2.6.27.

Is it trouble of kernel or software problem in my Debian system and what 
can be done with it?

-- 
With best regards, Sergey I. Sharybin

