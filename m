Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbXEHITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbXEHITU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEHITQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:19:16 -0400
Received: from www.osadl.org ([213.239.205.134]:36884 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934654AbXEHITP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:19:15 -0400
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 08 May 2007 10:21:59 +0200
Message-Id: <1178612519.3042.294.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 04:06 -0400, Robert P. J. Day wrote:
>   i've always hated that lower-level menu under "General setup":

Good reason to break everything which depends on CONFIG_EMBEDDED.

	tglx

> -menuconfig EMBEDDED
> -	bool "Configure standard kernel features (for small systems)"



