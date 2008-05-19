Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYESXXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYESXXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbYESXVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:35 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49302 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760992AbYESXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:20 -0400
Message-ID: <4831F933.2010908@keyaccess.nl>
Date: Tue, 20 May 2008 00:03:31 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 5/8] PNP: add pnp_resource_type_name() helper function
References: <20080505223630.682082986@ldl.fc.hp.com> <20080505223959.789928242@ldl.fc.hp.com>
In-Reply-To: <20080505223959.789928242@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 00:36, Bjorn Helgaas wrote:

> This patch adds a "pnp_resource_type_name(struct resource *)" that
> returns the string resource type.  This will be used by the sysfs
> "show resources" function and the debug resource dump function.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

