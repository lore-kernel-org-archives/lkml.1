Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYC0A3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYC0A3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYC0A3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:29:01 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:49334 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYC0A3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:29:00 -0400
Message-ID: <47EAEA98.7010500@keyaccess.nl>
Date: Thu, 27 Mar 2008 01:30:16 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups
References: <20080326171058.099442579@ldl.fc.hp.com> <200803261842.11023.lenb@kernel.org> <200803261713.03248.bjorn.helgaas@hp.com>
In-Reply-To: <200803261713.03248.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27-03-08 00:13, Bjorn Helgaas wrote:

> Oops, sorry, I forgot to export pnp_get_resource().  I'll post an updated
> patch as a response to the original.  Is that easy for you to handle,
> Len?  If not, let me know what you'd prefer.

Works for me at least. Only had time for a quick test. After applying these, 
my snd-cs4236 driver ISAPnP soundcard is no longer found.

Rene.

