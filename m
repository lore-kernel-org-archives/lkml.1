Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYLSTxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYLSTxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYLSTxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:53:22 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:62732 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYLSTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:53:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KdtyWBSZeVhtwzfCmyxYamTDc5Ds8VV088WmSG7RRFycVVDR0lVm9Is8pJv9hRZWNo
         tuVPGpjL4XQxM0iDCWIB2Kn7JAS2HziFoGqlY22pd/JPfLhaDnFtIvY47wbtzrBVTC6q
         gEVniSFpS5DzqrC53g1bZ3eRBg8XM2+J09mp0=
Message-ID: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
Date: Sat, 20 Dec 2008 01:23:20 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, "David Woodhouse" <dwmw2@infradead.org>
Subject: Firmware patches for SCSI
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

These SCSI's firmware patches are floating in linux-next from long time :

1. qla1280: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=7c84df1aec1bbb4e43ac9e2ba65b137042279a8d
2. advansys: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=baca2b168d3b7340eac87414c046f7d49de4bf71
3. qlogicpti: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=2c68b5b6db13786a425accc8576217b120f885f2

Should I need to resend these patches to merge main-stream.

Thank you,

Jaswinder Singh.
