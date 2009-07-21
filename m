Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZGUQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZGUQAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZGUP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:59:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53008 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753459AbZGUP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:59:59 -0400
Date: Tue, 21 Jul 2009 17:00:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721170055.10cce812@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721155620.GB13236@buzzloop.caiaq.de>
References: <20090721004531.1036d9af@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
	<20090721155620.GB13236@buzzloop.caiaq.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem is that freed resources are accessed, and that can lead to
> any kind of strange kernel faults from crashing to other subsequent
> errors.
> 
> Did you try my patch?

We've already established your patch is wrong. So trying it isn't at all
helpful.
