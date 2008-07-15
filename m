Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYGOCNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYGOCNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYGOCNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:13:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbYGOCNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:13:33 -0400
Date: Mon, 14 Jul 2008 19:13:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487C0365.5030203@garzik.org>
Message-ID: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Jeff Garzik wrote:
> 
> IMO the newly added /inability/ to build firmware into kernel modules is a
> clear regression.

IMO you're being stupid.

How about explainign why it makes any difference what-so-ever?

If you can load the module, you can load the firmware. Claiming anything 
else is just _stupid_.

And if you cannot see the advantage of having _one_ interface to firmware 
loading, instead of each driver picking a random approach, I don't know 
what to say.

The fact that some people have been confused and apparently blathered 
about memory savings is totally immaterial. Ignore the stupid people.

			Linus
