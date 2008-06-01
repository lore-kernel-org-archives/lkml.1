Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYFAV51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYFAV51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYFAV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:57:18 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60765 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYFAV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:57:18 -0400
Message-ID: <48431C03.1050207@keyaccess.nl>
Date: Mon, 02 Jun 2008 00:00:35 +0200
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
Subject: Re: [patch 10/15] PNP: remove redundant pnp_can_configure() check
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224933.357252074@ldl.fc.hp.com>
In-Reply-To: <20080530224933.357252074@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> pnp_assign_resources() is static and the only caller checks
> pnp_can_configure() before calling it, so no need to do it
> again.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.
