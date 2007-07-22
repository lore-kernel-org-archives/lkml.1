Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbXGVUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbXGVUpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763003AbXGVUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:45:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:58816 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632AbXGVUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fnJPyW3+BF3yuSONBZpVo4KUDY4xi+e3cLtsCgcRW8fqQjrnEn8zby04zOeyYOHpR3Zt/7XzQGQWo7ubjzYaXkV31e0+r8X0k7bkrWwF5hMHFfqnLRTPRjFtMar6EtmLB/hqP5G1TeNknqgNtmzEGhdM20z8KGfiDH4sQ7ELm3E=
Message-ID: <6101e8c40707221345gc24ed3o5ef3d379b85b400e@mail.gmail.com>
Date: Sun, 22 Jul 2007 22:45:44 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707222235130.32367@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
	 <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
	 <Pine.LNX.4.64.0707222235130.32367@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jul 22 2007 22:16, Oliver Pinter wrote:
> > Hi all!
> >
> > Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
> > for help, because number of person has the question: I have Pentium D,
> > and which CPU chose  I.
> >
> > arch/i386/Kconfig.cpu |   18 +++++++++---------
> > 1 files changed, 9 insertions(+), 9 deletions(-)
>
> But why move the config entry?
>

I thinked, sorted the items by time-line:
the old sort im Kconfig is i386..Pentium{I,II,III}..Core2..Pentium4
and the time line is    93 .. 95-99 .. 2006 .. 2001

and the new sort is:
... Pentium4 .. Core2

as the CPU-s manufactured.


>
>
>         Jan
> --
>

Thanks
Oliver
