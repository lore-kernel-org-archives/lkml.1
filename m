Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYFAVV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYFAVV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYFAVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:21:49 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39911 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYFAVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:21:48 -0400
Message-ID: <484313B1.7000701@keyaccess.nl>
Date: Sun, 01 Jun 2008 23:25:05 +0200
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
Subject: Re: [patch 05/15] PNP: introduce pnp_irq_mask_t typedef
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224932.360968516@ldl.fc.hp.com>
In-Reply-To: <20080530224932.360968516@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:48, Bjorn Helgaas wrote:

> This adds a typedef for the IRQ bitmap, which should cause
> no functional change, but will make it easier to pass a
> pointer to a bitmap to pnp_register_irq_resource().
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.
