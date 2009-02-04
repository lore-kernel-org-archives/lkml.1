Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZBDSH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZBDSH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZBDSHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:07:49 -0500
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:50458
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752121AbZBDSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:07:49 -0500
Message-ID: <4989D968.8070107@gridplexus.com>
Date: Wed, 04 Feb 2009 13:07:36 -0500
From: support <support@gridplexus.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: xen-2.6.18-92.1.22.el5.i686 with 2010s
References: <497E4821.6000902@gridplexus.com>
In-Reply-To: <497E4821.6000902@gridplexus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fyi: found a related post on the 2010s and xen kernel panic.

https://bugzilla.redhat.com/show_bug.cgi?id=481500


support wrote:
> Using kernel xen-2.6.18-92.1.22.el5.i686 with 2010s results in kernel 
> panic (not syncing).  The non-xen kernel is used in the initial 
> kickstart.  After verifying grub, disk labels in rescue mode, etc, I 
> am wondering if anyone has had success with the adaptec 2010s and 
> xen?  The same hardware boots successfully with the smp 2.6.18-92.1.22.
> grep  I2O .config
>
> # I2O device support
> CONFIG_SCSI_DPT_I2O=y
> # I2O device support
> CONFIG_I2O=m
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
>
>
> Thanks in advance.
> Robert
>
>

