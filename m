Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXBWL3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXBWL3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbXBWL3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:29:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55433 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932127AbXBWL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:29:15 -0500
Date: Fri, 23 Feb 2007 12:33:07 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Areca driver 2.6.19 on x86_64
Message-ID: <20070223123307.0b8ffc55@lxorguk.ukuu.org.uk>
In-Reply-To: <9113207.post@talk.nabble.com>
References: <3193.213.203.144.13.1165423892.squirrel@mailserver.omnibit.it>
	<20061206230949.GA25461@brong.net>
	<000301c719a9$70e4f8d0$2900a8c0@arecakevin>
	<9113207.post@talk.nabble.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With my distro hat on I'd also say that trying with acpi disabled is the
first call when debugging problems with IRQ delivery.

Alan
