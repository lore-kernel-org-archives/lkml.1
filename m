Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZLUKY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZLUKY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZLUKY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:24:26 -0500
Received: from ozlabs.org ([203.10.76.45]:59334 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZLUKYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:24:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Mon, 21 Dec 2009 20:54:17 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911231359.54544.rusty@rustcorp.com.au> <200912182052.42477.linux@rainbow-software.org>
In-Reply-To: <200912182052.42477.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212054.18055.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009 06:22:39 am Ondrej Zary wrote:
> Generate pnp:d aliases for isapnp_device_tables. This allows udev to load
> these modules automatically.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

I'm happy with this, so I've separated and taken them.  Too late for the
merge window I'm afraid, but it'll be in next one.

Thanks,
Rusty.
