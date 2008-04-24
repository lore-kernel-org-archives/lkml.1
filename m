Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYDXKhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYDXKhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYDXKgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:36:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56786
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755739AbYDXKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:36:45 -0400
Date: Thu, 24 Apr 2008 03:36:45 -0700 (PDT)
Message-Id: <20080424.033645.54639130.davem@davemloft.net>
To: bunk@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc64: cleanup after SunOS/Solaris binary
 emulation removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080423095151.GD28933@cs181133002.pp.htv.fi>
References: <20080423095151.GD28933@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 23 Apr 2008 12:51:51 +0300

> The following cleanups are now possible:
> - arch/sparc64/kernel/entry.S:ret_sys_call no longer has to be global
> - arch/sparc64/kernel/sparc64_ksyms.c:
>   remove no longer used prototypes
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
