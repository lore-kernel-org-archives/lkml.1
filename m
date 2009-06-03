Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZFCPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZFCPqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZFCPqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:46:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923AbZFCPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:46:07 -0400
Date: Wed, 3 Jun 2009 08:45:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Michael S. Zick" <lkml@morethan.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC: Style] Kernel coding style for Extended Attributes.
In-Reply-To: <200906031037.50803.lkml@morethan.org>
Message-ID: <alpine.LFD.2.01.0906030843340.4880@localhost.localdomain>
References: <200906031037.50803.lkml@morethan.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Michael S. Zick wrote:
> 
> Is there a recommended style for the kernel source?

I think the recommended style is:

  "Hide them behind a macro so that they never show up in the source".

and then basically nobody will care about whether there is a space between 
the __attribute__ and '(('.

		Linus
