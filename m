Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXEZF3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXEZF3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXEZF25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:28:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:57495 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbXEZF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dc5T7fk3W7B6z1F14tz1xe2ZI3KLjIlOQDIKhtEhQWMwijvjzVcs71jFaB+A5UzL/oMNGeFs8NcH3ECAE87zV/Ro/QRyvsN4LHoMPoq8ldYubS83gimW2UsFCOMSbqqUg8VYm0QrH3e8qlwqqTZTrZRUnvVNjZal8CGLb/VTLe8=
Message-ID: <2bd9ebfa0705252228u65b62ddbta2337ce56e77618a@mail.gmail.com>
Date: Sat, 26 May 2007 01:28:56 -0400
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: reg: modules make in Ubuntu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make[1]: Entering directory `/usr/src/linux-headers-2.6.20-15-generic'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
make[2]: *** No rule to make target `arch/i386/kernel/msr.c', needed
by `arch/i386/kernel/msr.o'.  Stop.
make[1]: *** [arch/i386/kernel] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.20-15-generic'
make: *** [all] Error 2

what the hack is this. no kernel version is having this file in this
particular location as asked in error. then why this error is coming
in this kernel version.

TEJ
