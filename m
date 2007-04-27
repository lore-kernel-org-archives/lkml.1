Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXD0X1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXD0X1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXD0X1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:27:23 -0400
Received: from gw.goop.org ([64.81.55.164]:36468 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXD0X1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:27:21 -0400
Message-ID: <463286D9.7090609@goop.org>
Date: Fri, 27 Apr 2007 16:27:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private
 data
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org> <20070424055731.GA30018@gondor.apana.org.au> <46327706.80508@goop.org> <20070427223742.GA2742@gondor.apana.org.au>
In-Reply-To: <20070427223742.GA2742@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> They can be applied separately so you don't need the dom0 part for your
> tree.

Great, thanks.

    J
