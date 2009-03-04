Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZCDO0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZCDO0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZCDO0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:26:42 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:29288 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZCDO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:26:42 -0500
Date: Wed, 4 Mar 2009 15:26:27 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]some cleanup on drivers/i2c/i2c-core.c
Message-ID: <20090304152627.72cfb798@hyperion.delvare>
In-Reply-To: <20090304133157.GA7629@helight>
References: <20090304133157.GA7629@helight>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 21:31:57 +0800, Zhenwen Xu wrote:
>  Some lines over 80. 
>  The printk(KERN_ERR ... ) should be dev_err.
>  And some blankspace should be deleted.

Applied, thanks!

Next time please send the patch to the linux-i2c list instead of
linux-kernel.

-- 
Jean Delvare
