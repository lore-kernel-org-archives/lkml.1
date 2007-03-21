Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXCUWID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXCUWID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXCUWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:08:03 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbXCUWIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:08:00 -0400
Date: Wed, 21 Mar 2007 15:07:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 2/4] cxgb3 - Auto-load FW if mismatch detected
Message-Id: <20070321150706.9b916d79.akpm@linux-foundation.org>
In-Reply-To: <20070318201006.16292.12877.stgit@localhost.localdomain>
References: <20070318201006.16292.12877.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 13:10:06 -0700
divy@chelsio.com wrote:

>  config CHELSIO_T3
>          tristate "Chelsio Communications T3 10Gb Ethernet support"
>          depends on PCI
> +	select FW_LOADER

Something has gone wrong with the indenting there.
