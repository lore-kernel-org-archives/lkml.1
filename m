Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYBSQiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYBSQiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBSQiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:38:13 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:51190 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYBSQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:38:13 -0500
Date: Tue, 19 Feb 2008 16:38:08 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.25 patch] mips: fix SNI_RM EISA=n compilation
Message-ID: <20080219163808.GA11006@linux-mips.org>
References: <20080217215948.GL1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217215948.GL1403@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 11:59:48PM +0200, Adrian Bunk wrote:

> This patch fixes the following build error with CONFIG_EISA=n caused by 
> commit 231a35d37293ab88d325a9cb94e5474c156282c0:

Applied.  Thanks,

  Ralf
