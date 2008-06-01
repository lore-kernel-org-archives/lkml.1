Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYFAVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYFAVES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYFAVEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:04:06 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34570 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYFAVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:04:04 -0400
Message-ID: <48430F6F.3040207@keyaccess.nl>
Date: Sun, 01 Jun 2008 23:06:55 +0200
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
Subject: Re: [patch 04/15] PNP: make resource option structures private to
 PNP subsystem
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224932.167361093@ldl.fc.hp.com>
In-Reply-To: <20080530224932.167361093@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:48, Bjorn Helgaas wrote:

> Nothing outside the PNP subsystem should need access to a
> device's resource options, so this patch moves the option
> structure declarations to a private header file.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

I guess this is dependent on the 8250_pnp note I sent earlier.

Rene.
