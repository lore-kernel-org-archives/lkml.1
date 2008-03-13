Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYCMRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYCMRB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:01:48 -0400
Received: from mx28.mail.ru ([194.67.23.67]:11337 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYCMRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:01:48 -0400
Message-ID: <47D95C34.3060302@mail.ru>
Date: Thu, 13 Mar 2008 21:54:12 +0500
From: Denis Lotarev <lot88@mail.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug?Devices:Network:Wi-Fi:Broadcom,Bug?Devices:Audio:Conexant
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to Linux Kernel Dev from Russian Linux beginner!
I have 2 big troubles:( My google searching dont have success result.
I have notebook Hewlett Packard HP530 with Wi-Fi Broadcom (lspci out:
 10:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan
 mini-PCI (rev 01)) and Conexant HD Audio (lspci out: 00:1b.0 Audio device:
 Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller
 (rev 01)) Im using Linux Slackware 12 (currently updated to current
 13/04/2008) and latest Linux Kernel (uname -a out: Linux hp_init 2.6.24.3
 #17 Thu Mar 13 09:46:20 YEKT 2008 i686 Intel(R) Celeron(R) M CPU      
  440  @ 1.86GHz GenuineIntel GNU/Linux) i have recompiled it with turned
 on Intel HD Audio - Conexant HD Audio and Generic HD-Audio codec
 parser) my sound card is detected well (dmesg|grep Intel out:  #0: HDA Intel
 at 0xf0580000 irq 17) Sound works well in internal speakers, but my
 headphones not working from headphone mini-jack. Now, lets talking about
 Broadcom wireless network adapter, its doesnt work too, but interface
 detected (its wlan0). I know that those adapters working with
 firmware (b43-fwcutter), but this chipset (BCM94311MCG) doesn't worked
 with this. I tried much variants with it, but nothing success:(( dmesg
 says about impossibility to load firmware ucode5.fw, but this file yet
 in /lib/firmware/b43/ Im trying to using all versions of broadcom
 drivers, but nothing works. Think, that my information is helpfully to
 developers. If you have some questions to me, I always greatly to answer on
 them. Hope, that dev team fix it or let me know some information how
 to fix those issue. Much thanks from Russian Linux User!

