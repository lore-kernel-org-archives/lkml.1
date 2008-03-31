Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYCaTrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYCaTrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYCaTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:46:53 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55554 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYCaTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:46:52 -0400
Message-ID: <47F14008.7050100@keyaccess.nl>
Date: Mon, 31 Mar 2008 21:48:24 +0200
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
References: <20080326171058.099442579@ldl.fc.hp.com> <200803261713.03248.bjorn.helgaas@hp.com> <47EAEA98.7010500@keyaccess.nl> <200803271150.30512.bjorn.helgaas@hp.com> <47F13E13.7090608@keyaccess.nl>
In-Reply-To: <47F13E13.7090608@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-03-08 21:40, Rene Herman wrote:

> On 27-03-08 18:50, Bjorn Helgaas wrote:
> 
>> Are any ISAPNP devices at all found?
> 
> Yes, but at most 100 * 10^4 / 2^16 percent of them. Trouble is in 04/37:

Well, that should read "Yes, no less than 100 * 10^4 / 2^16 percent of them 
even" but you get the point...

Rene.
