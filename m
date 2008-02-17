Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYBQTlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYBQTlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYBQTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:40:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18057 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbYBQTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=xJssSpNYNqe/74VdJqG7G5A1zhsUkb8KpDp9tbR5hBbC6QrM1/ux10naL7N/DAFs6IjYCOtx/6SWReJWxjuBfIXFH1Wu9gDhZFzTxARqqelPx/4bhu04qm7OueniiLqtm8iMZIp6ktHCqvXCHDwrb0l469LZi6sP0ko6FNmiq0U=
Date: Sun, 17 Feb 2008 20:40:53 +0100
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current git very broken on the Dreamcast
Message-Id: <20080217204053.f2f28eef.Kristoffer.ericson@gmail.com>
In-Reply-To: <1203187080.6737.3.camel@localhost.localdomain>
References: <1203187080.6737.3.camel@localhost.localdomain>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 18:38:00 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> Will seek to bisect this, but I have just updated my sources to the
> latest git and it is not booting at all on the Dreamcast.
> 
> With early printk on, I get nothing more than this before an instant
> reboot:

I haven't tested anything after 2.6.24 vanilla which works fine. A bisect sounds like a good idea since you
got pretty much zero clues.

> 
> [    0.000000] Linux version 2.6.25-rc2-10953-g52065cd
> (adrian@bossclass) (gcc version 3.4.6) #511 PREEMPT Sat Feb 16 18:31:43
> GMT 2008
> [    0.000000] console [sercon0] enabled
> [    0.000000] Booting machvec: Sega Dreamcast
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
