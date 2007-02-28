Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXB1PTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXB1PTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXB1PTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:19:05 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:54656 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933112AbXB1PTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:19:03 -0500
Message-ID: <45E59D64.3070202@blueyonder.co.uk>
Date: Wed, 28 Feb 2007 15:19:00 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
require a password to unlock, but it asks for password. When the screen
unlocks, kwin is gone with no errors logged in /var/log/kdm or
/var/log/messages. No problems with 2.6.20.

Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


