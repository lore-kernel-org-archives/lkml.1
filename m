Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbZLRIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbZLRIc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZLRIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:32:58 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46094 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZLRIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Dw910Xo3luT5juhBl0bfZ0NcP2ckNp9OlBkA0i9NGHbONwNyjRUjBZusm8xbIMvgLk
         Gl/8IIZCpfHGlu4mIdtSj6W0TviVv2ZDSAMrt+7DtpibM5wvmPbWqdnYp5NRglkqtuAg
         OA1Omh3ySRnGRqaOPktdAkzAHYjl4Cr/cpR9M=
Message-ID: <4B2B3EAF.2040302@gmail.com>
Date: Fri, 18 Dec 2009 16:34:55 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ibm-acpi-devel@lists.sourceforge.net
Subject: [x86]compile error
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux@linux-desktop:~/linux-2.6$ make modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  Building modules, stage 2.
  MODPOST 1834 modules
ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_boolean_mono_info" 
[drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko] 
undefined!
ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!

-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

