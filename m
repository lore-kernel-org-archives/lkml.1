Return-Path: <linux-kernel-owner+w=401wt.eu-S1762419AbXFDTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762419AbXFDTcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762126AbXFDTcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:32:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51468 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762118AbXFDTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:32:08 -0400
Date: Mon, 4 Jun 2007 13:32:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] old declaration ritchie style fix in arch/parisc/math-emu/
Message-ID: <20070604193206.GA8605@parisc-linux.org>
References: <877iqjr2en.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877iqjr2en.fsf@wanadoo.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 08:38:08PM +0200, Yoann Padioleau wrote:
> 
> Use consistent function ANSI declaration style.

This code is copied from HPUX and we'd prefer to not change it.  Thanks,
though.
