Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXEFKsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXEFKsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbXEFKsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:48:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:55539 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbXEFKsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:48:04 -0400
Message-ID: <463DB261.3000007@qumranet.com>
Date: Sun, 06 May 2007 13:48:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-22 release
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The happy theme of today's kvm is the significant performance 
improvements, brought to you by a growing team of developers.  I've 
clocked kbuild at within 25% of native.  This release also introduces 
support for 32-bit Windows Vista.

Changes from kvm-21:
- Significant performance improvements (Anthony Liguori, Eddie Dong, 
Qing He, me)
- Fix longstanding bug: time runs at double speed on x86_64 Linux (Qing He)
- Windows Vista 32-bit support (Qing He, Jun Nakajima)
- Support for kvm abi 10 modules
- Minor updates

Notes:
   If you use the modules from kvm-22, you can use any version of Linux
from 2.6.9 upwards.
   If you use the modules from Linux 2.6.20, you need to use kvm-12.
   If you use the modules from Linux 2.6.21, you need to use kvm-17.

   API/ABI stability is planned for Linux 2.6.22.

http://kvm.qumranet.com

-- 
error compiling committee.c: too many arguments to function

