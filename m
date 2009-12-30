Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZL3JNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZL3JNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZL3JNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:13:06 -0500
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:59514
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZL3JNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:13:05 -0500
Date: Wed, 30 Dec 2009 10:12:22 +0100 (CET)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: Florian Weimer <fweimer@bfk.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: ESX Server - GPL violation - found proof !?!
In-Reply-To: <82fx6sc04v.fsf@mid.bfk.de>
Message-ID: <alpine.LFD.2.00.0912301008160.25318@bbs.intern>
References: <alpine.LFD.2.00.0912300928070.20863@bbs.intern> <82fx6sc04v.fsf@mid.bfk.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-MailScanner-Information-wiesinger-com: Please contact the ISP for more information
X-wiesinger-com-MailScanner-ID: nBU9CMaU026693
X-MailScanner-wiesinger-com: Found to be clean
X-MailScanner-SpamCheck-wiesinger-com: not spam, SpamAssassin (not cached,
	score=-3.647, required 4.5, ALL_TRUSTED -1.80, AWL -0.64,
	BAYES_00 -2.60, PLING_QUERY 1.39)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009, Florian Weimer wrote:

> * Gerhard Wiesinger:
>
>> More clearly stated that ESX SERVER is based on Linux driver GPL code
>
> Historically, the drivers you mentioned have had close ties to the
> corresponding FreeBSD drivers and were dual-licensed.  So it is
> possible that Vmware obtained a non-GPL version of those drivers.
>

The mentioned version ncr53c8xx-3.4.3b is from Sat May 12 12:00 2001. From 
sources one can see that e.g. Alan Cox, Ronald van Cuijlenborg (and some 
others) made already GPL v2 changes in V1.10 and V1.9 from 1998 and 1997.

Therefore derived work is from GPL v2 code.

See for details:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git;a=blob;f=drivers/scsi/ChangeLog.ncr53c8xx;h=c91e792cab278e33811d377018b4251fa9887f29;hb=a07d8a1940dce21de61a9c3e38b887047d8e3629
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git;a=blob;f=drivers/scsi/NCR5380.c;h=cde30dc38ba6f3f1b90b9bc60414ff0406b1e558;hb=a07d8a1940dce21de61a9c3e38b887047d8e3629

Ciao,
Gerhard Wiesinger

--
http://www.wiesinger.com/


