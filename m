Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYAMSyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYAMSyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYAMSyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:54:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:14111 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYAMSyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:54:12 -0500
Date: Sun, 13 Jan 2008 10:52:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-doc@vger.kernel.org, "Ed L. Cashin" <ecashin@coraid.com>,
       Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add 00-INDEX file for AoE
Message-Id: <20080113105219.695d6c32.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
References: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 02:44:48 +0100 (CET) Jesper Juhl wrote:

> Documentation/aoe/ is missing a 00-INDEX file. Add one.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Jesper.

> ---
> 
>  00-INDEX |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> --- /dev/null	2005-11-21 04:22:37.000000000 +0100
> +++ linux-2.6/Documentation/aoe/00-INDEX	2008-01-13 02:37:29.000000000 +0100
> @@ -0,0 +1,18 @@
> +00-INDEX
> +	- this file.
> +aoe.txt
> +	- ATA over Ethernet (AoE) driver user guide and pointer to tools.
> +autoload.sh
> +	- script for making the AoE driver autoload via /etc/modprobe.conf.
> +mkdevs.sh
> +	- script for creating required AoE device nodes.
> +mkshelf.sh
> +	- script for making one shelf's worth of block device nodes.
> +status.sh
> +	- script to collate and present sysfs information about AoE storage.
> +todo.txt
> +	- list of things yet to be done for the AoE driver.
> +udev-install.sh
> +	- script to install the aoe-specific udev rules from udev.txt.
> +udev.txt
> +	- list of udev rules for AoE device node creation.

---
~Randy
