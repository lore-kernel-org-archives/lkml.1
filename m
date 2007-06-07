Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbXFGPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbXFGPtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762197AbXFGPti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:49:38 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:55037 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbXFGPth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:49:37 -0400
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 11:49:36 EDT
Message-ID: <46682233.7000501@net4.in>
Date: Thu, 07 Jun 2007 20:50:19 +0530
From: Gaurav Pruthi <gaurav.p@net4.in>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel Panic Error [2.6.21.1 on FC4]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using FC4 with Kernel Version of 2.6.17-1.2142 & 2.6.11-1.1369. I 
tried to install 2.6.21.1 from source.
Installation goes well without any error. But when I rebooted my system 
in this new kernel. I got kernel panic error. Initially i got error 
related to Label for / . So i edited grub.conf & fstab and put drive 
path (/dev/sdx) instead of label. But then I got this error. I am unable 
to understand this error.

mount: error 6 mounting ext3
Error opening /dev/console!!!!: 2
error dup 2'ing fd of 0 to 0
error dup 2'ing fd of 0 to 1
error dup 2'ing fd of 0 to 2

Switchroot: mount failed :22




--
Gaurav
