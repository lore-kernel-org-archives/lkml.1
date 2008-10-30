Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYJ3XTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYJ3XTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYJ3XTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:19:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbYJ3XTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:19:16 -0400
Date: Thu, 30 Oct 2008 16:19:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
In-Reply-To: <1225403551.3322.42.camel@norville.austin.ibm.com>
Message-ID: <alpine.LFD.2.00.0810301618160.21084@nehalem.linux-foundation.org>
References: <20081030054944.GA19035@kroah.com>  <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org> <1225403551.3322.42.camel@norville.austin.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Oct 2008, Dave Kleikamp wrote:
>
> Is bisection really important for a new driver?

It's not the new driver that matters.

It's bisecting all the other _unrelated_ bugs, and then ending up in the 
middle of the driver history.

			Linus
