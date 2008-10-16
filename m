Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYJPKVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYJPKVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYJPKVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:21:24 -0400
Received: from h155.mvista.com ([63.81.120.155]:55028 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbYJPKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:21:23 -0400
Message-ID: <48F7159D.4040709@ru.mvista.com>
Date: Thu, 16 Oct 2008 14:21:17 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: powerpc allmodconfig
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
In-Reply-To: <20081015213337.a99a9595.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> drivers/ide/pci/hpt366.c: In function 'init_hwif_hpt366':
> drivers/ide/pci/hpt366.c:1292: warning: unused variable 'dev'
>   

   Patch (even two) for this one has been submitted

> drivers/ide/pci/scc_pata.c: In function 'init_hwif_scc':
> drivers/ide/pci/scc_pata.c:846: warning: unused variable 'ports'
>   

   Hm, but not for this one...

> drivers/serial/serial_txx9.c: In function 'serial_txx9_probe':
> drivers/serial/serial_txx9.c:1041: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
>   

   Atsushi-san, are you seeing this one?

MBR, Sergei


