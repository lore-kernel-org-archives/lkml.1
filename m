Return-Path: <linux-kernel-owner+w=401wt.eu-S1161354AbXCIASz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161354AbXCIASz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161355AbXCIASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:18:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41884 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161354AbXCIASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:18:55 -0500
Subject: Re: [PATCH] Complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org
In-Reply-To: <20070308.161407.63995586.davem@davemloft.net>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <20070308.161407.63995586.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 00:18:49 +0000
Message-Id: <1173399529.3461.542.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 16:14 -0800, David Miller wrote:
> The rest, like ioperm, iopl, modify_ldt, et al. are i386
> specific.

Thanks for the update. Quite why the PowerPC kernel defines system call
numbers for all of these I have no idea :)

-- 
dwmw2

