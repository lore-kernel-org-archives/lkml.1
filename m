Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYDDUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYDDUWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYDDUWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:22:36 -0400
Received: from oss.sgi.com ([192.48.170.157]:44525 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbYDDUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:22:35 -0400
Date: Fri, 4 Apr 2008 21:22:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Alchemy: move UART platform code to its proper place
	(take 2)
Message-ID: <20080404202228.GB5959@linux-mips.org>
References: <200804041733.45170.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804041733.45170.sshtylyov@ru.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 05:33:45PM +0400, Sergei Shtylyov wrote:

> Move the code registering the Alchemy UART platform devices from drivers/serial
> to its proper place, into the Alchemy platform code.  Fix the related Kconfig
> entry, while at it...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

2.6.26 queue updated,

  Ralf
