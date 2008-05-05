Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYEETKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYEETKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYEETKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:10:32 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:41649 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752852AbYEETKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:10:32 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] drivers/pci/pci.c: add prototypes
Date: Mon, 5 May 2008 12:10:28 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080505182547.GT17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182547.GT17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051210.28908.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 11:25 am Adrian Bunk wrote:
> This patch adds prototypes for pcibios_disable_device() and
> pcibios_set_pcie_reset_state() in include/linux/pci.h
>
> While I was at it, I also removed the unneeded "extern" from the
> prototype of pcibios_add_platform_entries().
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to my linux-next branch.  Thanks.

Jesse
