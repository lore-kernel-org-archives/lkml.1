Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbZFCRL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbZFCRL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZFCRLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:11:50 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:38106 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbZFCRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:11:49 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC: Style] Kernel coding style for Extended Attributes.
Date: Wed, 3 Jun 2009 12:11:47 -0500
User-Agent: KMail/1.9.9
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906031037.50803.lkml@morethan.org> <alpine.LFD.2.01.0906030843340.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906030843340.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031211.49890.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed June 3 2009, Linus Torvalds wrote:
> 
> On Wed, 3 Jun 2009, Michael S. Zick wrote:
> > 
> > Is there a recommended style for the kernel source?
> 
> I think the recommended style is:
> 
>   "Hide them behind a macro so that they never show up in the source".
>

That seems to be the general consensus in (/by) practice.

Thanks,
Mike  

> and then basically nobody will care about whether there is a space between 
> the __attribute__ and '(('.
> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


