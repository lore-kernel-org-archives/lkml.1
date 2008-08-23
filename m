Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYHWCmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYHWCmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 22:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYHWCmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 22:42:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYHWCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 22:42:25 -0400
Date: Fri, 22 Aug 2008 19:41:31 -0700
From: Greg KH <greg@kroah.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV
Message-ID: <20080823024131.GA22675@kroah.com>
References: <20080822215509.GE143104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822215509.GE143104@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 04:55:09PM -0500, Russ Anderson wrote:
> [PATCH 4/4] x86: Add sysfs entries for UV
> 
> Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>

As you adding new sysfs files, please document them in Documentation/ABI
as well.

thanks,

greg k-h
