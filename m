Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbYFNKm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbYFNKm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbYFNKkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:40:35 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55137 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbYFNKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:40:34 -0400
Message-ID: <48537C01.80202@keyaccess.nl>
Date: Sat, 14 Jun 2008 10:06:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 03/18] PNP: IORESOURCE_* flags are PNP-specific, not ISA
 PNP-specific
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221127.351243617@ldl.fc.hp.com>
In-Reply-To: <20080604221127.351243617@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-06-08 00:09, Bjorn Helgaas wrote:

> Change comments on the bus-specific IORESOURCE bit definitions
> to indicate the PNP ones are not ISA-specific.  They are used
> by PNPBIOS and PNPACPI in addition to ISAPNP.
> 
> Rene Herman <rene.herman@gmail.com> wrote this patch:
>     http://marc.info/?l=linux-acpi&m=121200787202959&w=4.
> I picked it up to resolve conflicts with other patches.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

