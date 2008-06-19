Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYFSNHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYFSNHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbYFSNHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:07:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbYFSNHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:07:33 -0400
Date: Thu, 19 Jun 2008 14:55:08 +0200
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andre Haupt <andre@bitwigglers.org>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: remove duplicate include of linux/interrupt.h
Message-ID: <20080619125508.GA11645@ahaupt-debian-vm.localdomain>
References: <1213879388-11418-1-git-send-email-andre@bitwigglers.org> <20080619125115.GA10549@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619125115.GA10549@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX1/e4QAUE0UFfkc7yYxR6zHT5zrucrFoAvdVZAn
 XhGXaYIsMvalve7IVl6q4ueAxKUPkyyvimnWWm448zLQnjD7J7
 DPy2PSCiPNzYpUjZqn/ugIDBmJfxR7ye1VLlci6Vm8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:51:15PM +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Thu, Jun 19, 2008 at 02:43:08PM +0200, Andre Haupt (andre@bitwigglers.org) wrote:
> > Signed-off-by: Andre Haupt <andre@bitwigglers.org>
> 
> Thank you for the patch,  but similar one from Huang Weiyi is in Herbert Xu
> cryptodev-2.6 tree an will be pushed upstream in upcoming merge window.
> 
Ok, didn't notice that.

regards,

Andre


> -- 
> 	Evgeniy Polyakov
