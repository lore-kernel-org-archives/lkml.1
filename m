Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762Ab0A2PV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0A2PV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293Ab0A2PV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:21:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35305 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139Ab0A2PVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:21:54 -0500
Date: Fri, 29 Jan 2010 15:23:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Derek Atkins <warlord@mit.edu>
Cc: linux-kernel@vger.kernel.org, warlord@mit.edu
Subject: Re: Re-enabling non-GPL driver access to disk partition information
Message-ID: <20100129152314.04c0c634@lxorguk.ukuu.org.uk>
In-Reply-To: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> get information about existing partitions.  All those interfaces are now
> GPL-Only,

The kernel is GPL licensed. Please don't assume an EXPORT_SYMBOL() means
the GPL does not apply or that this magically indicates it isn't a
derivative work.

Alan
