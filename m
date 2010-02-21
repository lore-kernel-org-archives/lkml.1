Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0BUQci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:32:38 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53209 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0BUQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fKk9dPZzaoATtLS5iQW7i1wxvlyjl7Os3pfjtld4jbP/FvYqoo0qjaibD1zHeXtfJp
         /mxSJquqB3zcno4guZ7DCcv3nOZTk3kPHZi2mkxs23iyD5f6oDCzCdMpwLUomAOAtw+N
         lAf2uJwMvo3XkpkFQPfvwBE6JiYrTXb1cMTRQ=
Date: Sun, 21 Feb 2010 17:30:22 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: Re: 2.6.33-rc8-git: nouveaufb hangs on boot on MacBookPro5,3
Message-ID: <20100221163022.GA3277@joi.lan>
References: <1266444104.6276.49.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266444104.6276.49.camel@no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 11:01:44PM +0100, Soeren Sonnenburg wrote:
> Dear all,
> 
> nouveaufb hangs on MacBookPro5,3 with PFIFO_INTR 0x04000000 - Ch1 when
> booting in efi mode via elilo.
> 
> I am attaching a (dirty) screenshot, maybe someone can clear this up
> 
> http://sonnenburgs.de/media/bugs/nouveau_hang_2.6.33-rc8.jpg
> 
> If there is anything else you want me to try, please say so.
> 
> Soeren

cc nouveau mailing list
