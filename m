Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYLKP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYLKP0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYLKPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:25:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38222 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYLKPZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:25:57 -0500
Date: Thu, 11 Dec 2008 10:25:08 -0500
From: Jason Baron <jbaron@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081211152508.GA3124@redhat.com>
References: <20081210073347.GA18737@localhost> <1228904326.19553.127.camel@violet.holtmann.net> <20081210144058.GA11842@localhost> <20081210152323.GB446@suse.de> <20081210234317.GA5904@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210234317.GA5904@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 07:43:17AM +0800, Wu Fengguang wrote:
> Got it. Below is the updated patch based on Marcel's one.
> 
> Thanks,
> Fengguang
> ---
> dynamic_printk: reduce one level of indentation
> 
> Cleanup pr_debug_write() to reduce one level of indentation.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

thanks for the cleanup.

Acked-by: Jason Baron <jbaron@redhat.com>

