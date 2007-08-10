Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbXHJCxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbXHJCxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXHJCxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:53:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60421 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXHJCxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:53:36 -0400
Date: Thu, 9 Aug 2007 22:53:22 -0400
Message-Id: <200708100253.l7A2rMWG024728@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: JFFS2/mtdsuper modprobe "unknown symbol" in 2.6.23-rc1 
In-reply-to: Your message of "Fri, 10 Aug 2007 04:44:22 +0200."
             <20070810024422.GF18938@stusta.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070810024422.GF18938@stusta.de>, Adrian Bunk writes:
> On Thu, Aug 09, 2007 at 10:38:18PM -0400, Erez Zadok wrote:
> > I'm getting an error modprobing jffs2 due to mtdsuper failing to insmod:
> >...
> > Does anyone know what am I missing?
> 
> You miss that 2.6.23-rc2 with this bug fixed has already been released.

Great, I'll upgrade to rc2 (I've had this problem since .22-rc).  Thanks for
the quick response.

Erez.
