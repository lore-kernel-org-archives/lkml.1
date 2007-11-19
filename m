Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbXKSFNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbXKSFNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXKSFNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:13:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39643 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXKSFN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:13:29 -0500
Date: Sun, 18 Nov 2007 21:09:21 -0800
From: Greg KH <greg@kroah.com>
To: Marcel Selhorst <tpm@selhorst.net>
Cc: Richard MUSIL <richard.musil@st.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] - TPM device driver layer (tpm.c|h)
Message-ID: <20071119050921.GB12320@kroah.com>
References: <46CD497F.8030207@st.com> <4740C70F.8050407@selhorst.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4740C70F.8050407@selhorst.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 12:13:19AM +0100, Marcel Selhorst wrote:
> Dear all,
> 
> sorry for the delay. The patch below was posted 3 months ago and fixes
>  possible problems during unloading of TPM device drivers.
> 
> Acked by: Marcel Selhorst <tpm@selhorst.net>

Ok, but shouldn't you be sending this patch onward to Andrew and/or
others?

Who is the TPM driver maintainer these days?

thanks,

greg k-h
