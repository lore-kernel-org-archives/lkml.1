Return-Path: <linux-kernel-owner+w=401wt.eu-S965276AbXA3Pzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbXA3Pzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965308AbXA3Pzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:55:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50702 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965276AbXA3Pzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:55:38 -0500
Date: Tue, 30 Jan 2007 16:05:36 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
Message-ID: <20070130160536.0ec0a99c@localhost.localdomain>
In-Reply-To: <200701301329.03334.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701291600.32580.jdelvare@suse.de>
	<20070129155125.74758322@localhost.localdomain>
	<200701301329.03334.jdelvare@suse.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 13:29:03 +0100
Jean Delvare <jdelvare@suse.de> wrote:

> Alan,
> 
> Le Lundi 29 Janvier 2007 16:51, Alan a écrit :
> > This is a lot neater than the original patch too. Only problem I see is
> > pci=reverse might need more care.
> 
> What do you mean exactly? I thought pci=reverse had been dropped years ago?

Good point - pci=bfsort/nobfsort are the current "lets do things in a
funny order" options, and those ought to be ok.

Alan
