Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbZJIMqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbZJIMqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 08:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbZJIMqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 08:46:54 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:33364 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZJIMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 08:46:54 -0400
Date: Fri, 9 Oct 2009 14:46:11 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CIRS: turn local_save_flags() +
	local_irq_disable()into local_irq_save()
Message-ID: <20091009124611.GF24141@axis.com>
References: <alpine.LSU.2.00.0910091138500.19284@wotan.suse.de> <20091009105215.GC24141@axis.com> <alpine.LSU.2.00.0910091414540.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910091414540.19284@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 02:15:34PM +0200, Jiri Kosina wrote:
> On Fri, 9 Oct 2009, Jesper Nilsson wrote:
> > > This is a followup to my patches that fixed this all over the tree quite some
> > > time ago. This one went unnoticed for some reason.
> > > TLB handling for CRIS contains local_irq_disable() after local_save_flags().
> > > Turn this into local_irq_save().
> > 
> > Thanks, that looks good.
> 
> I will then add
> 
> 	Acked-by: Jesper Nilsson <Jesper.Nilsson@axis.com>
> 
> to it if you don't mind (the same for the old debug stuff removal).

Absolutely, and thank you. :-)

> Thanks,

> Jiri Kosina

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
