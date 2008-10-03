Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYJCB6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYJCB6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 21:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYJCB60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 21:58:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbYJCB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 21:58:25 -0400
Date: Thu, 2 Oct 2008 18:58:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] check mapped ranges on sysfs resource files (for
 2.6.27)
In-Reply-To: <200810021651.29081.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0810021857350.3230@nehalem.linux-foundation.org>
References: <200810021534.38219.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0810021630100.3341@nehalem.linux-foundation.org> <200810021651.29081.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Oct 2008, Jesse Barnes wrote:
> 
> Yeah, looks much better.  I was using this silly test program to see if the 
> earlier code worked.  Just pass in both valid and invalid sizes.

All right, it seems to pass your test program, so I committed it with your 
ack and quoting your original reason for doing this.

		Linus
