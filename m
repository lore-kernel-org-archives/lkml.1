Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYAXUG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYAXUG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYAXUGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:06:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33738 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbYAXUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:06:20 -0500
Date: Thu, 24 Jan 2008 20:05:59 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] mount options: fix adfs
Message-ID: <20080124200559.GA4093@flint.arm.linux.org.uk>
References: <20080124193341.166753833@szeredi.hu> <20080124193419.142002297@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193419.142002297@szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 08:33:44PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a .show_options super operation to adfs.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
