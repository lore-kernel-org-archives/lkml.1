Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXDXEe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXDXEe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXDXEe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:34:29 -0400
Received: from gw.goop.org ([64.81.55.164]:45396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXDXEe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:34:28 -0400
Message-ID: <462D88EF.9030007@goop.org>
Date: Mon, 23 Apr 2007 21:34:55 -0700
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
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au>
In-Reply-To: <20070424014528.GA27789@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Thanks Jeremy.  The patch looks good.

Could you give netfront an overall review as well?  I know you're
already pretty familiar with it, but if you could cast a fresh eye over
it, that would be helpful.

Thanks,
    J
