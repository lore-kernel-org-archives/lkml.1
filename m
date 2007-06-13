Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXFMGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXFMGA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXFMGAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:00:14 -0400
Received: from sd291.sivit.org ([194.146.225.122]:2730 "EHLO sd291.sivit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbXFMGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:00:12 -0400
Subject: Re: [RFC][PATCH 1/1] support for user-space buffers in kfifo
From: Stelian Pop <stelian@popies.net>
To: Nelson Castillo <nelsoneci@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070613022124.GA31974@emqbit.com>
References: <20070613022124.GA31974@emqbit.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 13 Jun 2007 08:00:10 +0200
Message-Id: <1181714411.7991.5.camel@voyager.dsnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 juin 2007 à 21:21 -0500, Nelson Castillo a écrit :
> On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> > Le mardi 12 juin 2007 à 11:24 -0500, Nelson Castillo a écrit :
> > > On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> > > (cut)
> > > > accessing userspace memory with a spinlock taken (moreover an
> > > > irqsave()
> > > > one) is bad bad bad.
> > >
> > > Hi Stelian.
> > >
> > > I'm sending the new patch without kfifo_put_user and kfifo_get_user.
> > 
> > Ok, I have a few formatting/documentation comments:
> 
> Applied, thanks.
> 
> > Other than that I'm ok with this patch.
> 
> Submitting.
> 
> Regards, Nelson.-
> 
> Signed-off-by: Nelson Castillo <nelson@emqbit.com>

Signed-off-by: Stelian Pop <stelian@popies.net>

Thanks,

Stelian.

-- 
Stelian Pop <stelian@popies.net>

