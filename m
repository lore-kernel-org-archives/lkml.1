Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYD2NAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYD2NAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYD2M76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:59:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYD2M75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:59:57 -0400
Date: Sun, 27 Apr 2008 22:47:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Gabriel C <crazy@frugalware.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Dave Airlie <airlied@linux.ie>, Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
Message-ID: <20080427224724.18c11b94@infradead.org>
In-Reply-To: <4815EEB4.2060509@frugalware.org>
References: <4815EEB4.2060509@frugalware.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 17:35:16 +0200
Gabriel C <crazy@frugalware.org> wrote:

> Hello ,
> 
> are there any plans to add G33 / Q33 / Q35 chipsets support for the
> intelfb driver ? Is this driver still maintained ?
> 
> ( I'm not really sure who maintains this driver so I've add peoples
> to CC I saw worked on it , I've also added Wang Zhenyu to CC while he
> added this support for AGP )
> 
> 

the real answer is to not use intelfb, at least not until the modesetting work lands in the kernel.
(and after that... do you really need it?)
