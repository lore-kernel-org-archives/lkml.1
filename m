Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZBDAUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZBDAUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbZBDATw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:19:52 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:32054 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZBDATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aUh1KaQ+fZ9IGav42U6dmfNS0xd3l42hFmfk+NaQW+8eetPto1KsuVqOXAUoTud50d
         2ZH2ioZRGMS3Qo1N/2oyiylekvtnmerUIUFuUqkVSoLt0jhC+gyuV2oDWkwXs6o+qsJl
         xREoPMPZlJr02a0kWcOx6Hm0spc35h0kzpQW8=
Date: Tue, 3 Feb 2009 19:19:47 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: Parag Warudkar <parag.lkml@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: WARNING: at drivers/pci/pci-driver.c:368
In-Reply-To: <alpine.DEB.2.00.0902031912520.7017@parag-laptop>
Message-ID: <alpine.DEB.2.00.0902031918260.7017@parag-laptop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902032315.27113.rjw@sisk.pl> <alpine.DEB.2.00.0902031821590.7302@parag-laptop> <200902040110.21455.rjw@sisk.pl> <alpine.DEB.2.00.0902031912520.7017@parag-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Parag Warudkar wrote:

> Actually judging by the INT disabled message that appears after the 
> WARN_ON - 
> 
> 0000:01:00.0: PCI INT A disabled
> 
> It seems to be the PCI bridge that was in D0 - 

Of course I meant was NOT in D0 ..

Parag
