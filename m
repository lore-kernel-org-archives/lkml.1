Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXJIRj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXJIRj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXJIRjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:39:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7287 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXJIRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:39:19 -0400
Message-ID: <fa686aa40710091039hd945eb4n7dfdba3df37a08f2@mail.gmail.com>
Date: Tue, 9 Oct 2007 11:39:18 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 0/6] Patch series to add of_platform binding to xilinxfb
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akonovalov@ru.mvista.com, linuxppc <linuxppc-dev@ozlabs.org>,
       "Paul Mackerras" <paulus@samba.org>
In-Reply-To: <1191906242.6083.7.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
	 <1191370502.5238.1.camel@daplas>
	 <fa686aa40710082143k2092e7d2l35bc3bda55bb6237@mail.gmail.com>
	 <1191906242.6083.7.camel@daplas>
X-Google-Sender-Auth: c977a52a176a9a13
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Mon, 2007-10-08 at 22:43 -0600, Grant Likely wrote:
> > BTW, what path do framebuffer patches take to get into Linus' tree?
> > Does he pull your tree directly, or do they go through someone else's
> > tree?
>
> They all go to -mm tree, unless it's a needed fix, then to Linus's.
>
> Tony

Ah, okay.

Since the XilinxFB is a powerpc-only device, is it okay with you if I
get Paul Mackerras to merge them into his tree instead (that way the
changes go in with the platform code which requires these changes)

Paulus, is that okay by you?

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
