Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYBSO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYBSO0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYBSO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:26:08 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41394 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYBSO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:26:05 -0500
Date: Tue, 19 Feb 2008 14:26:03 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mips: finish the Qemu platform removal
Message-ID: <20080219142603.GA15037@linux-mips.org>
References: <20080217200951.GI1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217200951.GI1403@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:09:51PM +0200, Adrian Bunk wrote:

> The following files can now be removed:
> - arch/mips/configs/qemu_defconfig
> - include/asm-mips/qemu.h

Applied.  Thanks,

  Ralf
