Return-Path: <linux-kernel-owner+w=401wt.eu-S1946319AbXBCPV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946319AbXBCPV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946455AbXBCPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:21:56 -0500
Received: from 263.net.cn ([211.150.96.21]:47346 "EHLO smtp.263.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946319AbXBCPVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:21:55 -0500
X-KSVirus-check: 0
X-ABS-CHECKED: 0
X-SENDER-IP: 221.201.75.142
X-LOGIN-NAME: linux
Subject: Re: Some process went UNINTERRUPTABLE forever.
From: "Di, Wu" <linux@51sun.cn>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1170515191.3655.10.camel@linux-soc5.51sun.cn>
References: <1170515191.3655.10.camel@linux-soc5.51sun.cn>
Content-Type: text/plain
Date: Sat, 03 Feb 2007 15:22:33 +0000
Message-Id: <1170516153.4307.4.camel@linux-soc5.51sun.cn>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly when I save the file to the media(A Removable Disk with XFS
Filesystem.)

On Sat, 2007-02-03 at 15:06 +0000, Di, Wu wrote:
> The process status of 'pdflush' went to UNINTERRUPTIBLE forever, and
> then I edit some file(in other media) use 'vi', the 'vi' also went to
> that status. And I cannot even reboot my system, instead I need use the
> power button.
> I am using Kernel-2.6.20-rc6-mm3 with 'preemptible' option.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


