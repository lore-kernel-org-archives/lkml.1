Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYKGFQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYKGFQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYKGFPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:15:55 -0500
Received: from mail172.messagelabs.com ([216.82.254.3]:38350 "EHLO
	mail172.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYKGFPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:15:54 -0500
X-VirusChecked: Checked
X-Env-Sender: buddhike.desilva@readify.net
X-Msg-Ref: server-11.tower-172.messagelabs.com!1226034949!211803!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [203.89.209.186]
From: Buddhike De Silva <buddhike.desilva@readify.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2008 16:15:36 +1100
Subject: Compiling a small kernel on Ubuntu
Thread-Topic: Compiling a small kernel on Ubuntu
Thread-Index: AclAl94HHS51mShqRAqDMYWet85hFw==
Message-ID: <B635664A870E3E409144F6DDD84ABA3C3842945EE2@rpmail01.solar.system>
Accept-Language: en-US, en-AU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-AU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

I'm trying to learn how linux scheduler is implemented. As a result, I wanted to compile and run linux kernel from its source code. That way I can assure that I have a working base to play around. I started by following this article:
http://www.digitalhermit.com/linux/Kernel-Build-HOWTO.html

I managed to complete the given instructions and change Grub to display a new entry to select the newly compiled kernel. However, it falls over while trying to load (unable to handle kernel paging request). My gut feeling says I've missed something in the kernel configuration step. Can someone please tell me the basic set of options required for a kernel to get the following system up and running?

Machine: IBM thinkpad t42
CPU:  Intel Centrino Mobile 32bit
RAM: 1 GB
Hard Disk: 40GB IDE

Also is there a guide for kernel debugging? Thanks a lot in advance.

Cheers,
Buddhike
