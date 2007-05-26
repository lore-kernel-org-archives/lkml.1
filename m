Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXEZDHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXEZDHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 23:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXEZDHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 23:07:44 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:17170 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXEZDHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 23:07:43 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 23:07:43 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=C25S6G7jHWZujzNK+Ta6Skv0sOBwDfrmn+PWbP+oHxqtIvhTB6kqZsvtNJ/H28exgEW7eGoJzXkDQUE08vVvrtvLSC5Y4dHT7syim/As3x4BxMjIstV0fqihstTZjkWX;
X-IronPort-AV: E=Sophos;i="4.14,581,1170655200"; 
   d="scan'208";a="274533951"
Date: Fri, 25 May 2007 21:58:09 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Tim Gardner <rtg@tpi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tim.gardner@ubuntu.com
Subject: Re: [PATCH 1/1] Work around Dell E520 BIOS reboot bug.
Message-ID: <20070526025809.GA23351@lists.us.dell.com>
References: <20070523191244.50078196AA1@rtg.theglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523191244.50078196AA1@rtg.theglobal.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 01:12:44PM -0600, Tim Gardner wrote:
> From: Tim Gardner <tim.gardner@ubuntu.com>
> Subject: [PATCH] Work around Dell E520 BIOS reboot bug.
> 
> Force Dell E520 to use the BIOS to shutdown/reboot.
> 
> Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>

Acked-by: Matt Domsch <Matt_Domsch@dell.com>

Thanks Tim for submitting this.
-Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
