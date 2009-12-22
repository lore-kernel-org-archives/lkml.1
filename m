Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZLVNNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZLVNNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZLVNNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:13:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZLVNNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:13:09 -0500
Date: Tue, 22 Dec 2009 14:13:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Vrabel <david.vrabel@csr.com>
Cc: peterhuewe@gmx.de, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] uwb/i1480: add __init/__exit macros
In-Reply-To: <4B30B975.20602@csr.com>
Message-ID: <alpine.LNX.2.00.0912221412550.3755@pobox.suse.cz>
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de> <4B30B975.20602@csr.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, David Vrabel wrote:

> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of
> 
> Acked-by: David Vrabel <david.vrabel@csr.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
