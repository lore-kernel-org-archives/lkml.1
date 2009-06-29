Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZF2KTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZF2KTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZF2KTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:19:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53075 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZF2KTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:19:33 -0400
Subject: Re: kmemleak hexdump proposal
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090629101917.GA3093@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
	 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
	 <20090629101917.GA3093@localdomain.by>
Date: Mon, 29 Jun 2009 13:19:34 +0300
Message-Id: <1246270774.6364.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Mon, 2009-06-29 at 13:19 +0300, Sergey Senozhatsky wrote:
> Well, it's not easy to come up with something strong. 
> I agree, that stack gives you almost all you need.
> 
> HEX dump can give you a _tip_ in case you're not sure. 

Don't get me wrong, I'm not against it in any way. If Catalin is
interested in merging this kind of functionality, go for it! You might
want to consider unconditionally enabling the hexdump. If the
information is valuable, we should print it all the time.

			Pekka

