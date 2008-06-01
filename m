Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYFAVld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYFAVld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYFAVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:41:24 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45132 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYFAVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:41:23 -0400
Message-ID: <48431848.6050102@keyaccess.nl>
Date: Sun, 01 Jun 2008 23:44:40 +0200
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
Subject: Re: [patch 08/15] PNP: in debug resource dump, make empty list obvious
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224932.974122201@ldl.fc.hp.com>
In-Reply-To: <20080530224932.974122201@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> If the resource list is empty, say that explicitly.  Previously,
> it was confusing because often the heading was followed by zero
> resource lines, then some "add resource" lines from auto-assignment,
> so the "add" lines looked like current resources.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.
