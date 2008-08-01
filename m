Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYHBAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYHBAGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYHBAGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:06:37 -0400
Received: from ozlabs.org ([203.10.76.45]:60164 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYHBAGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:06:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18579.41468.973986.175252@cargo.ozlabs.ibm.com>
Date: Sat, 2 Aug 2008 09:53:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] powerpc: Remove use of CONFIG_PPC_MERGE
In-Reply-To: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> This set of patches remove Kconfig and code related to CONFIG_PPC_MERGE
> and !CONFIG_PPC_MERGE.  There is some discussion about that one last
> use of !PPC_MERGE with respect to the 4xx MTD_NAND_NDFC driver.
> 
> Paul, is this something you'd be willing to entertain for 2.6.27?

Yes, since it's just dead code removal.

Paul.
