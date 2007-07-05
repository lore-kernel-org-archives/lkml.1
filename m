Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXGEAqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXGEAqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbXGEAoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:44:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbXGEAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:44:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.15630.812698.367707@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:36:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, <rjw@sisk.pl>, <mjg59@srcf.ucam.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
References: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu>
	<Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> wanting to resume devices during a system suspend transition?  This is
> exactly what happens when those threads aren't frozen.

So, I wonder why I don't see that error on my powerbook?

Paul.
