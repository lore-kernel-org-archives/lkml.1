Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYIPHdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYIPHdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYIPHdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:33:12 -0400
Received: from m12-12.163.com ([220.181.12.12]:55474 "HELO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751961AbYIPHdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:33:11 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 03:33:11 EDT
Date: Tue, 16 Sep 2008 15:15:46 +0800
From: "Bily" <hsssss1111@163.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: insmod problem
Message-ID: <200809161515454846111@163.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUUYxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUjx8YjsxI4VWUJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1I0E4x80
	FVCIwcAKzIAtM7C26IkvcIIF6IxKo4kEV4yl1IIY67AEw4v_Jr0_Jr4ln4vEbcI7uVAqrc
	v_JFW8Xr15M2vYz4IE04k24VAvwVAKI4IrMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lFVAaXTZC67ZELSn0mTvEwa
	V2v3VFvVW8M4IE42xK82IY64kIx2x0424l7I0Y64k_MxkI7II2jI8vz4v_Cr0_Zr1l4x8a
	6c8ajcxJMI8E67AF67kF1VAFwI0_Jr0_JrylIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVWUJVW8JwCqF7xvr2IY62kE34x0Y4UvcSsGvfC2KfnxnUUI43ZE
	Xa7xRuOJeDUUUUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,all;
    I want to insert an module:yaffs.ko into my kernel2.6.26,but i meet this question:

[\u@\h \W]$insmod yaffs.ko 
yaffs: unknown relocation: 40
insmod: cannot insert 'yaffs.ko': invalid module format

and my busybox version is v1.11.1; may anyone tell me why ?thanks!


Bily
2008-09-13


