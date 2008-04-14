Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYDNTxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYDNTxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYDNTxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:53:04 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:53708 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641AbYDNTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:53:04 -0400
Message-ID: <4803B6C6.2020608@keyaccess.nl>
Date: Mon, 14 Apr 2008 21:55:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: ambx1@neo.rr.com, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [2.6 patch] drivers/pnp/manager.c cleanups
References: <20080414184038.GB6695@cs181133002.pp.htv.fi>
In-Reply-To: <20080414184038.GB6695@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-08 20:40, Adrian Bunk wrote:

> This patch contains the following cleanups that are now possible:
> - remove the following unused functions:
>   - pnp_manual_config_dev()
>   - pnp_resource_change()
> - remove the following unused EXPORT_SYMBOL's:
>   - pnp_start_dev
>   - pnp_stop_dev
>   - pnp_init_resource_table
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Bjorn Helgaas (added to CC) is busy here, including doing the above. Don't 
know if he minds this not going through his own set...

Rene.
