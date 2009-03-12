Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZCLOUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZCLOUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZCLOUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:20:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:42668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZCLOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:20:20 -0400
Date: Thu, 12 Mar 2009 07:21:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System tick rate
Message-ID: <20090312072110.0a325543@infradead.org>
In-Reply-To: <alpine.LSU.2.00.0903121435190.3835@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903121435190.3835@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 14:38:19 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

> Hi,
> 
> 
> is there an "official" way of obtaining the current tick rate when 
> CONFIG_NO_HZ? 

what does "current tick rate" mean for you in a no-hz situation ?
is it the HZ value (which is supposed to be invisible from userspace,
so good luck) or the wakeup count ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
