Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321Ab0ATQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0ATQiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493Ab0ATQiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:38:13 -0500
Received: from xenotime.net ([72.52.64.118]:40628 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751122Ab0ATQiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:38:12 -0500
Date: Wed, 20 Jan 2010 08:38:06 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       ok@artecdesign.ee, sarah.a.sharp@linux.intel.com,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] Obsolete config in kernel source (USB_HCD_DMA)
Message-Id: <20100120083806.25b69d9f.rdunlap@xenotime.net>
In-Reply-To: <4B571122.6060407@ru.mvista.com>
References: <20100120123540.GB3580@faui49.informatik.uni-erlangen.de>
	<4B571122.6060407@ru.mvista.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 17:20:18 +0300 Sergei Shtylyov wrote:

> Hello.
> 
> Christoph Egger wrote:
> 
> > From 2e5a8a322a6cd74ecb77eda8f0a09a0a01c6dbc6 Mon Sep 17 00:00:00 2001
> > From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> > Date: Wed, 20 Jan 2010 13:32:36 +0100
> > Subject: [PATCH] The configuration Option USB_HCD_DMA is not reachable in KConfig so
> >  this piece of Code is effectively dead and useless. Remove it to avoid
> >  confusion.
> >   
> 
>    The patch's subject should be a terse description of change, not the 
> substitute for the lengthy description as in your case.

Also please insert patches inline in the email body instead of using
attachments.  mutt can surely do this -- people do it all the time
(though I don't use mutt, so please don't ask me how).

---
~Randy
