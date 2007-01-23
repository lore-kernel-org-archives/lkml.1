Return-Path: <linux-kernel-owner+w=401wt.eu-S965161AbXAWOtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161AbXAWOtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965165AbXAWOtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:49:43 -0500
Received: from il.qumranet.com ([62.219.232.206]:43098 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161AbXAWOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:49:42 -0500
Message-ID: <45B62080.9090006@qumranet.com>
Date: Tue, 23 Jan 2007 16:49:36 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-12 release
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps the most visible change is that -no-acpi is no longer required 
to install Windows (it is still recommended as the Windows ACPI HAL will 
eat a lot of cpu time).

Changes from kvm-11:

- More migration work (Uri Lublin)
- savevm/loadvm (and migration) work on AMD (Leonard Norrgard)
- More guest support
- mmu testsuite and fixes
- Windows ACPI install/run support (Dor Laor)
- Fix host reboot on guest reboot on AMD (Joerg Roedel)

http://kvm.sourceforge.net

-- 
error compiling committee.c: too many arguments to function

