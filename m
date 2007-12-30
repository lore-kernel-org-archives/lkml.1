Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXL3SZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXL3SZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXL3SZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:25:29 -0500
Received: from mail.emergencycommunicationsystems.com ([24.123.23.170]:57070
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXL3SZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:25:28 -0500
Message-ID: <4777E295.3060700@pagestation.com>
Date: Sun, 30 Dec 2007 13:25:25 -0500
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071020)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel crash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running kernel 2.6.23.9
last night I had a crash.
This was all that was in the /var/log/messages.
I run centos 5.1 with the above kernel.
This was late at night noone was using the machine.
The machine is an AMD 6400+ X2, NVIDIA (with nvidia drivers). Software 
RAID with 2 seagate 500GIG drives as raid-1.

Any know issues with this?

Dec 29 20:28:04 devcentos5x64 kernel: Unable to handle kernel paging 
request at 00000000ffff8160 RIP:
Dec 29 20:28:04 devcentos5x64 kernel:  [<ffffffff88035502>] 
:jbd:journal_commit_transaction+0x328/0x100a
Dec 29 20:28:04 devcentos5x64 kernel: PGD 101af3067 PUD 0
Dec 29 20:28:04 devcentos5x64 kernel: Oops: 0002 [1] SMP


Jerry
