Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbXJIFES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbXJIFES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXJIFEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:04:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:29515 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXJIFEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KjxCr9xuvt3XzaSFMfnYxevG+aHk/gFxPRe7lNiGKHrixJpq8EV/mO6JLFDtiqun8nCzTEyY7YR0jKe4toyRtFaMQz7En858ZwkwOCpvstzJJc0b57M3ro6/SpqSB5EydQj6HWAOYweHnUmac+5iQVVhxPfyipLjwMiI4CwBpcs=
Subject: Re: [Linux-fbdev-devel] [PATCH 0/6] Patch series to add
	of_platform binding to xilinxfb
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akonovalov@ru.mvista.com, linuxppc <linuxppc@ozlabs.org>
In-Reply-To: <fa686aa40710082143k2092e7d2l35bc3bda55bb6237@mail.gmail.com>
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
	 <1191370502.5238.1.camel@daplas>
	 <fa686aa40710082143k2092e7d2l35bc3bda55bb6237@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 13:04:02 +0800
Message-Id: <1191906242.6083.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 22:43 -0600, Grant Likely wrote:
> On 10/2/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Mon, 2007-10-01 at 09:57 -0600, Grant Likely wrote:
> > > Assuming there are no major issues, I'd like to get this patch series
> > > queued up for inclusion in 2.6.24.
> >
> > Okay.
> >
> > Tony
> 
> BTW, what path do framebuffer patches take to get into Linus' tree?
> Does he pull your tree directly, or do they go through someone else's
> tree?

They all go to -mm tree, unless it's a needed fix, then to Linus's.

Tony


