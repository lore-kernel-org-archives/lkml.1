Return-Path: <linux-kernel-owner+w=401wt.eu-S935177AbZJORNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177AbZJORNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935161AbZJORNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:13:00 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:64137 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935159AbZJORNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fcON5Ig51OOfscdrj6s4cGyvPS1QmtuvNLqrMP2P2RZkiEv24SjBcU/gE0aupMud7F
         CMfTW3WLm3FBr/yahrghNzbFB5Zz2oahbbDxu7KGYTtIymu4fkhnVP8/jADuYdebDsRo
         7PMjJAwsueg6TruuvVQAGJoIOCbY73RxdP59k=
Date: Thu, 15 Oct 2009 19:13:46 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: cbouatmailru@gmail.com
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Russell King <linux@arm.linux.org.uk>,
       Eric Miao <eric.y.miao@gmail.com>, linux-mtd@lists.infradead.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] mtd: maps: remove obsolete ipaq-flash driver
Message-Id: <20091015191346.39750c54.kristoffer.ericson@gmail.com>
In-Reply-To: <20091015165320.GA24086@oksana.dev.rtsoft.ru>
References: <1255433694-26471-1-git-send-email-mad_soft@inbox.ru>
	<20091015165320.GA24086@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 20:53:20 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Tue, Oct 13, 2009 at 03:34:54PM +0400, Dmitry Artamonow wrote:
> > This driver seems to be obsolete and broken for a long time.
> > It depends on CONFIG_IPAQ_HANDHELD that simply doesn't exists
> > anywhere in kernel. Also, it seems that none of machines it
> > claims to support have any use of it:
> >  SA11xx-based iPAQs (h3100/h3600) use sa1100-flash
> >  iPAQ h5000 uses physmap-flash
> >  Jornada 720 uses sa1100-flash
> >  Jornada 560 and iPAQ h1910 are not in mainline
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> 
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Same here.

> 
> Thanks!
> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
