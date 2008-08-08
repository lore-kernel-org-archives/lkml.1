Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYHHXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYHHXeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYHHXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:33:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYHHXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:33:58 -0400
Date: Fri, 8 Aug 2008 16:26:35 -0700
From: Greg KH <greg@kroah.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Patches to support QE USB Host Controller
Message-ID: <20080808232635.GB5352@kroah.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808161717.GA19095@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 08:17:17PM +0400, Anton Vorontsov wrote:
> Hi all,
> 
> Most patches that were needed to support QE USB Host were merged during
> 2.6.27 merge window, and only three more patches left over. Here they
> are.
> 
> David, could you bear with gpio_to_chip() exported function, just as
> a stopgap for a proper api?

I'll hold off on the 3rd patch until david takes the first two.

thanks,

greg k-h
