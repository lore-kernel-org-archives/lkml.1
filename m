Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbYESXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbYESXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbYESXVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:11 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55777 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYESXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:05 -0400
Message-ID: <4831F8FB.9010003@keyaccess.nl>
Date: Tue, 20 May 2008 00:02:35 +0200
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
Subject: Re: [patch 4/8] PNP: add pnp_resource_type() internal interface
References: <20080505223630.682082986@ldl.fc.hp.com> <20080505223959.587664764@ldl.fc.hp.com>
In-Reply-To: <20080505223959.587664764@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 00:36, Bjorn Helgaas wrote:

> Given a struct resource, this returns the type (IO, MEM, IRQ, DMA).
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

