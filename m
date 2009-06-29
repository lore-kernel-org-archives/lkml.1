Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZF2KmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZF2KmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZF2KmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:42:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41197 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZF2KmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:42:14 -0400
Subject: Re: kmemleak hexdump proposal
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1246271880.21450.13.camel@pc1117.cambridge.arm.com>
References: <20090628173632.GA3890@localdomain.by>
	 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
	 <20090629101917.GA3093@localdomain.by>
	 <1246270774.6364.9.camel@penberg-laptop>
	 <1246271880.21450.13.camel@pc1117.cambridge.arm.com>
Date: Mon, 29 Jun 2009 13:42:15 +0300
Message-Id: <1246272135.6364.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Mon, 2009-06-29 at 11:38 +0100, Catalin Marinas wrote:
> Anyway, I may not include it before the next merging window (when is
> actually the best time for new features). Currently, my main focus is on
> reducing the false positives.

Yes, this new feature shouldn't go into 2.6.31. That said, you _do_ want
to include it in linux-next now if you're interested in pushing it to
2.6.32.

			Pekka

