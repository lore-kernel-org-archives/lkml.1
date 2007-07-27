Return-Path: <linux-kernel-owner+w=401wt.eu-S1766013AbXG0AgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766013AbXG0AgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXG0Af5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:35:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXG0Af4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:35:56 -0400
Date: Thu, 26 Jul 2007 17:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
Message-Id: <20070726173501.9ba466ba.akpm@linux-foundation.org>
In-Reply-To: <m3abtir95x.fsf@maximus.localdomain>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 02:18:34 +0200 Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Josh Triplett <josht@linux.vnet.ibm.com> writes:
> 
> > +This also does not apply to a do-while loop; always use braces with a do-while,
> > +even if it contains a single statement:
> 
> I can't see anything wrong with
> 
> do
> 	abc;
> while (xyz);
> 

Me either, but whatever.

> and even if I could, "always use" seems way too strong in this case.

it's better that we all do things the same way.  What that way _is_ is
actually less important, unless it's something stupid, of course.

In this case, most of the code I've seen uses the braces (I think).

