Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab0BQG6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 01:58:18 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:53657 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779Ab0BQG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 01:58:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hKUMOA+zduhqpa5dByXsQ5fEZ4MrQN4pxADCpbcAWjkDB882VS9ElWSLCt3U4nie/f
         c0Ed61sPB1Z8IlyrgMxo8EL8F2jlYTxr2XKa0w+f5De1rSTNY1bxqWdszVbAEFLKplwS
         yHcCgvJ9pCH+VFR13QdHOZtcERolcvwJauXgo=
Message-ID: <4B7B9241.9070101@garzik.org>
Date: Wed, 17 Feb 2010 01:52:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: The Government <the_g0vernment@yahoo.com>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_mv driver support for Marvell Hercules II controller in
 newer kernels
References: <549084.45576.qm@web45206.mail.sp1.yahoo.com>
In-Reply-To: <549084.45576.qm@web45206.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 10:44 PM, The Government wrote:
> Hey guys,
>
> I'm using a Supermicro aoc-sat2-mv8, which is supposedly supported by the Linux kernel by "sata_mv" driver. Unfortunately, I've been unable to troubleshoot why newer distros (and thus kernels) are not detecting/using sata_mv for this card. I tried an (older) Slackware 12.1 install disk, that for some reason works by use of sata_mv (12.1 was released may 2008, when I think sata_mv was still beta). Anyhow, I've tried many newest releases from Slackware, Arch, etc - and it seems newer kernels do not properly recognize this card. I'm not sure what to make of the newer kernels saying "adaptec aacraid driver" is being used (an incorrectly detected driver?). Anyway, I was told this chipset had great linux support - does it still? Thanks a lot.
>
> (please CC me for replies, thanks a lot)

(cc linux-ide added)

We need a lot more hard detail, such as lspci and dmesg output.

	Jeff


