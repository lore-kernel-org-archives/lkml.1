Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXJIVGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXJIVGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbXJIVGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:06:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:63350 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXJIVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZdcFusu0VRFbvyVV2ZjyYVZpIVyU0AsRX4wNBryzP6vkaB6GEN75ysPdeIbEr3TegL/+TPC2HH7lh+p8iNqIfCZjNsxCx83N7BZpHFnyq2YYswl2B3bCS8MYqKrIClxBnMMMdl5idwjgLEcimTL1+oQJDqdOwoj5QY8JJkq1Gdk=
Subject: Re: [Linux-fbdev-devel] [PATCH 0/6] Patch series to add
	of_platform binding to xilinxfb
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akonovalov@ru.mvista.com, linuxppc <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <fa686aa40710091039hd945eb4n7dfdba3df37a08f2@mail.gmail.com>
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
	 <1191370502.5238.1.camel@daplas>
	 <fa686aa40710082143k2092e7d2l35bc3bda55bb6237@mail.gmail.com>
	 <1191906242.6083.7.camel@daplas>
	 <fa686aa40710091039hd945eb4n7dfdba3df37a08f2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 05:06:12 +0800
Message-Id: <1191963972.5446.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 11:39 -0600, Grant Likely wrote:
> On 10/8/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Mon, 2007-10-08 at 22:43 -0600, Grant Likely wrote:
> > > BTW, what path do framebuffer patches take to get into Linus' tree?
> > > Does he pull your tree directly, or do they go through someone else's
> > > tree?
> >
> > They all go to -mm tree, unless it's a needed fix, then to Linus's.
> >
> > Tony
> 
> Ah, okay.
> 
> Since the XilinxFB is a powerpc-only device, is it okay with you if I
> get Paul Mackerras to merge them into his tree instead (that way the
> changes go in with the platform code which requires these changes)

Fine with me.

Tony

