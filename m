Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXCTTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXCTTwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXCTTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:52:22 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:48061 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXCTTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:52:21 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
Date: Tue, 20 Mar 2007 20:53:00 +0100
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20061214223718.GA3816@elf.ucw.cz> <45A0041F.4060903@zytor.com> <20070319122740.286f602e.randy.dunlap@oracle.com>
In-Reply-To: <20070319122740.286f602e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202053.01615.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Monday 19 March 2007, Randy Dunlap wrote:
> Were there any patches written after this?  If so, I missed them.
> If not, does this patch help any?

How is division by zero avoided? Maybe one can avoid setting it to zero.

Regards

Ingo Oeser
