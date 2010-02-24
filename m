Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0BXOAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:00:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab0BXOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:00:39 -0500
Date: Wed, 24 Feb 2010 05:58:33 -0800
From: Greg KH <gregkh@suse.de>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Reminder: [PATCH 1/1] Staging: samsung-laptop: fix coding style
Message-ID: <20100224135833.GA22414@suse.de>
References: <48d47a051002240545j191214b8q85513be58b738726@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d47a051002240545j191214b8q85513be58b738726@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Reminder"?  What is that in the Subject: for?

On Wed, Feb 24, 2010 at 02:45:38PM +0100, Tom Van Braeckel wrote:
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
> ---
>  drivers/staging/samsung-
> laptop/samsung-laptop.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c
> b/drivers/staging/samsung-laptop/samsung-laptop.c
> index 4877138..dd7ea4c 100644
> --- a/drivers/staging/samsung-laptop/samsung-laptop.c
> +++ b/drivers/staging/samsung-laptop/samsung-laptop.c
> @@ -99,7 +99,8 @@ static struct rfkill *rfk;
> 
>  static int force;
>  module_param(force, bool, 0);
> -MODULE_PARM_DESC(force, "Disable the DMI check and forces the driver to be
> loaded");

Your patch is line-wrapped :(


> +MODULE_PARM_DESC(force,
> +               "Disable the DMI check and forces the driver to be loaded");

And the tabs are not here either.

and also, someone already sent in this fix, sorry.

thanks,

greg k-h
