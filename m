Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0BKQwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:52:17 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51610 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab0BKQwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=B7cUSyW1ot1wVhbvAozXUO4h8esefbiRYpO6Y6X0aib9RpzBFICTqD9SRxOyKx4jbn
         rrnTwbnt7zrjNYgwU9P20wVNHb8jEOfSxcRDJE3U7oZLZlWFlpqjjdqybTx4l6aLrreb
         W9LG7FAEps/7d3xZZiWEj9pHIpVOI6WgOj+3c=
Date: Thu, 11 Feb 2010 18:56:42 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Thomas Weber <weber@corscience.de>, broonie@opensource.wolfsonmicro.com,
       perex@perex.cz, tiwai@suse.de, jkrzyszt@tis.icnet.pl,
       anuj.aggarwal@ti.com, x0052729@ti.com, peter.ujfalusi@nokia.com,
       tony@atomide.com, jy0922.shim@samsung.com, linux-omap@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCHv2 3/4] Add ASoC support for Devkit8000
Message-Id: <20100211185642.34eb234e.jhnikula@gmail.com>
In-Reply-To: <1265901628.3179.14.camel@odin>
References: <1265901239-31285-1-git-send-email-weber@corscience.de>
	<1265901628.3179.14.camel@odin>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 15:20:28 +0000
Liam Girdwood <lrg@slimlogic.co.uk> wrote:

> On Thu, 2010-02-11 at 16:13 +0100, Thomas Weber wrote:
> > This patch expands the omap3beagle sound soc for the
> > beagle board clone DevKit8000.
> > 
> > Signed-off-by: Thomas Weber <weber@corscience.de>
> 
> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
> 
Acked-by: Jarkko Nikula <jhnikula@gmail.com>

Note, this is safe to push even if this goes to mainline before the
basic board file and arch/arm/mach-omap2/Kconfig change from linux-omap.
The machine type and so machine_is_devkit8000() are already there.


-- 
Jarkko
