Return-Path: <linux-kernel-owner+w=401wt.eu-S2992851AbXCCBQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992851AbXCCBQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992856AbXCCBQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:16:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992851AbXCCBQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:16:54 -0500
Message-ID: <45E8CC85.4040309@garzik.org>
Date: Fri, 02 Mar 2007 20:16:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Fix mv643xx_eth compilation.
References: <200702271559.l1RFxJXN013132@hera.kernel.org> <20070228204139.GA30657@redhat.com>
In-Reply-To: <20070228204139.GA30657@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Commit 908b637fe793165b6aecdc875cdca67c4959a1ad removed ETH_DMA_ALIGN
> but missed a usage of it in a macro, which broke the build.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

applied


