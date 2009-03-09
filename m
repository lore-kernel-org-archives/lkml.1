Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZCIJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZCIJoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZCIJoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:44:01 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:44593 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZCIJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=R5fKTpMl+Ii5xDf9DFsobZFoptQIYNRykbXLRiWUp3MH5tr53piI6dEt8f0u9d8nXA
         4+lKEIipCRsP4x9u2eySw0renLUriL5RCmXMyJx5LAcDRZ7iRpNfB/ZQTVUyteFBEsY7
         /CvE8SwIk0KP8MzHR5sxIBMV/SRgFnsi0NWAI=
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 10:43:57 +0100
Message-ID: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
Subject: Linux* Processor Microcode Data File
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was browsing Intel web site for my processor docs and I bumped
on download link "Linux* Processor Microcode Data File" and it says
there:

"The microcode data file contains the latest microcode definitions for
all Intel processors.
Intel releases microcode updates to correct processor behavior as
documented in the respective
processor specification updates. While the regular approach to getting
this microcode update is via
a BIOS upgrade, Intel realizes that this can be an administrative
hassle. The Linux Operating System
and VMware ESX products have a mechanism to update the microcode after
booting. For example,
this file will be used by the operating system mechanism if the file
is placed in the /etc/firmware
directory of the Linux system."

So, does new kernel versions just copy this microcode update file in
/etc/firmware folder or new
instructions are replaced in assembly code ?

greet
