Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbYGOR1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbYGOR1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOR1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:27:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYGOR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:27:06 -0400
Date: Tue, 15 Jul 2008 10:25:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CDB85.3050208@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151024220.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> 
 <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org>
 <487C5ABE.2010907@garzik.org> <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org> <487CDB85.3050208@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> The changes are good,
> 
> They just don't need to break stuff.
> 
> Which they do.

If you were serious about that, then you'd be suggesting _fixes_.

I'm not seeing you do that. I'm just seeing non-productive "we should 
never have changed" emails.

See my emails about what can be _productive_ avenues to explore. As it is, 
I have yet to see a _single_ productive email from you. 

Really, Jeff.

		Linus
