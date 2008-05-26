Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYEZFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYEZFuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYEZFue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 01:50:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbYEZFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 01:50:34 -0400
Date: Sun, 25 May 2008 22:50:29 -0700 (PDT)
Message-Id: <20080525.225029.89310488.davem@davemloft.net>
To: bunk@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc64: global_reg_snapshot is not for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080525165813.GC1791@cs181133002.pp.htv.fi>
References: <20080525165813.GC1791@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 25 May 2008 19:58:13 +0300

> global_reg_snapshot shouldn't be visible in our userspace headers.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
