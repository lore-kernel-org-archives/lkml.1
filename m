Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbXEMLjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbXEMLjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 07:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXEMLjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 07:39:06 -0400
Received: from mail.websurfer.com.np ([63.219.0.28]:59527 "EHLO
	mail.websurfer.com.np" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbXEMLjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 07:39:05 -0400
X-Antivirus-MYDOMAIN-Mail-From: umesh@websurfer.com.np via mail.websurfer.com.np
X-Antivirus-MYDOMAIN: 1.25-st-qms (Clear:RC:1(63.219.0.28):. Processed in 0.056104 secs Process 12850)
Message-ID: <2417.63.219.2.2.1179056431.squirrel@mail.websurfer.com.np>
Date: Sun, 13 May 2007 17:25:31 +0545 (NPT)
Subject: upgrade linux kernel
From: umesh@websurfer.com.np
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am upgrading kernel from 2.4.20-8(default in RH9) to 2.6.xx. when I do
"make" command it gives some output and finally get error saying that,

"BFD: Warning: Writing section '.bss' to huge ( ie negative) file offset
0xc0244000. "

 "Objcopy: arch/i386/boot/compressed/vmlinux.bin: file truncated"

"make[2]:***[ arch/i386/boot/compressed/vmlinux.bin] Error 1"

 "make[1]: ***[ arch/i386/boot/compressed/vmlinux] Error 2"

 "make: *** [bzImage] Error 2"



Thanks


