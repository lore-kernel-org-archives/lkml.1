Return-Path: <linux-kernel-owner+w=401wt.eu-S1031030AbXDUN6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031030AbXDUN6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031076AbXDUN6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:58:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:10672 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031030AbXDUN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DMW7kEP+V9aIdw8MsjrUU5dXHLZBw7kpM/I9vM1xEhBCuwrUjCPQ1wdp3B30Klfl8fTDJFKpccyU9gKs4h0PgrSpLoKlTRXU+ZGfyVLIzsOLYcnBsQNlJPetkErISmv+R591XWbFEiElDeVfwlPCZELUlH2E6li8opsOMbgq2xk=
Message-ID: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
Date: Sat, 21 Apr 2007 19:28:30 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.20.7 - Hard Disk rumbling?
Cc: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am facing a strange problems with an old 1.2 GHz P-III machine with
a 10 GB disk (used as a dedicated web server, later retired out of
service!).

Out of interest to implement some wireless solution (experiment), I
did compile 2.6.20.7 for my requirement. Strangely, I did observe:-

hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xb0

What might be the problem?

~Akula2
