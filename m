Return-Path: <linux-kernel-owner+w=401wt.eu-S935546AbXJPVhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935546AbXJPVhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935065AbXJPVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:37:29 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:25787 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbXJPVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=Aoa9DReObURG3hBaoCWlP+R9e/5f3PWYbqwXQYwdONFGaiL+NdKy/E2H4f745MaPJBBi7kJmtAJHRsZRsLAmABxMFB+fxLcclwrGVUUt0ttjhM452Pk5jEhUYhuOpRU9Co0j0KaZzKvz9X0vxuF36ltCcfrHS7lDAIRoXmwAog4=
Date: Tue, 16 Oct 2007 23:37:27 -0700
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : IDE-CS Add additional id string (corsair, 1GB)
Message-Id: <20071016233727.bd36bcbf.Kristoffer.ericson@gmail.com>
In-Reply-To: <200710162135.51149.bzolnier@gmail.com>
References: <20071014210403.13d6f560.Kristoffer.Ericson@Gmail.com>
	<200710162135.51149.bzolnier@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 21:35:51 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Monday 15 October 2007, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > The manf string looks weird (0x0 + 0x0), but I assume its correct. Also,
> > whitespaces seems almost intentional, so am I missing something? 
> 
> Nope, thanks for cleaning this.
Ah, good.

> 
> > Shortlog:
> > This patch adds id strings for Corsair 1GB (identified as Hyperstone Model1)
> > inside legacy/ide-cs.c 
> > 
> > It also includes some minor whitespace cleanups.
> > 
> > Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 
> applied
Thanks.
