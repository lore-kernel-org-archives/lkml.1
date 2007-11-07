Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXKGRP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXKGRP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXKGRPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:15:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXKGRPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:15:36 -0500
Date: Wed, 7 Nov 2007 09:08:20 -0800
From: Greg KH <greg@kroah.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107170820.GB8358@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107134255.GE14646@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> Greg,
> 
> Perfmon sysfs document has been updated following your adivce.
> you can check out in my perfmon tree  the following commit:
> 
> 	e83278f879e52ecee025effe9ad509fd51e4a516

Where is this git tree located?  On git.kernel.org somewhere?

thanks,

greg k-h
