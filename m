Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZCXM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZCXM2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbZCXM2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:28:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36298 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760067AbZCXM2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:28:12 -0400
Date: Tue, 24 Mar 2009 12:29:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324122900.06efc50d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324122211.GS12613@charite.de>
References: <20090324120948.GO12613@charite.de>
	<20090324121608.19f71ce2@lxorguk.ukuu.org.uk>
	<20090324122211.GS12613@charite.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is your userspace configured to use /lib/firmware/2.6.29 or the more
> > usual /lib/firmware/ ?
> 
> Which leads to the next question: How to I find out?

Consult your distribution ? or stick it in both places and see 8)
