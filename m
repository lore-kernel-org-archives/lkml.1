Return-Path: <linux-kernel-owner+w=401wt.eu-S1423039AbXBPCQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423039AbXBPCQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 21:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423045AbXBPCQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 21:16:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:4338 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423039AbXBPCQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 21:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Fw1vsxBqLX6oHpsbUNv+k/aU9ir/4vo0DjztP7AArBC5S8bdvvJdEUluGT+gQQaTI9lQ8s3b/0O6CtK8NNFSMvPcFDnea8og0Lu+zBH0vIF9uLbIbCvS/ZjS5qiYB8kehhXVMglmPskWQdflqPXEYQL+K/ZqXMWI+K8/RcGQ02s=
Message-ID: <7783925d0702151816r7df63816ld9c69b56bdb0a0b9@mail.gmail.com>
Date: Fri, 16 Feb 2007 07:46:00 +0530
From: "Rick Brown" <rick.brown.3@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       linux-newbie@vger.kernel.org
Subject: kernel porting query
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a very basic query regarding kernel porting on different
boards. I understand that even if two boards have the very same
processor core (say MIPS 4KE), we need to port linux for them
seperately. I have heard things like it is because of certain "board
level differences", I need to provide some "board specific hooks"
because the boards may contain "different devices" and so on ....

1) Can any one please shed some light on precisely and exactly what
are differences in different boards for which we need to port linux?

2) Also, I would appreciate if you could point out code portions /
source files that need to be changed in the process of porting Linux?

TIA,

Rick
