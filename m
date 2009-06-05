Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZFEUQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZFEUQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZFEUQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:16:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53324 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876AbZFEUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:16:37 -0400
Date: Fri, 5 Jun 2009 21:16:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-ID: <20090605211647.2f118a5c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090605184608.GA29250@havoc.gtf.org>
References: <20090605184608.GA29250@havoc.gtf.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 14:46:08 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

Missing

    libata: Use IGN_SIMPLEX for ALi

which you said you'd kick upstream and without which lots of ALi users
now get no DMA on half their devices due to PM changes.

