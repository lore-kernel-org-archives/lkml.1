Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbXGWBSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbXGWBSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXGWBRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:17:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:10185 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbXGWBRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FI5oDv4p/DaW6jWclpPbD2ymgKwq0dr3y3kot3bBcu8D/HhyruoNMj1yRxCQJpaeU8gGGO450n72Ad7sxvAiayHlXAC0YQtohc9FJmbtLTUI6XY+BKEjIeNxrxxsN7gZ6AqyYvxDC4J6kV6k5IbmuFGYPqtDQYQqBp4LJCggxr8=
Message-ID: <46A40130.30001@googlemail.com>
Date: Mon, 23 Jul 2007 03:15:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: shannon.nelson@intel.com
Subject: Re: drivers/dma/ioatdma.c - address of '__this_module' will always
 evaluate as 'true' , warning
References: <46A3FE3E.20300@googlemail.com>
In-Reply-To: <46A3FE3E.20300@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> I got this warning on current git using gcc 4.2.1 :
> 
> ...
> 
> drivers/dma/ioatdma.c: In function 'ioat_init_module':
> drivers/dma/ioatdma.c:816: warning: the address of '__this_module' will always evaluate as 'true'
> 
> ...
> 
> 
> Regards,
> 
> Gabriel C
> 

[ uhh send it to the wrong list sorry , added LKML now ] 
