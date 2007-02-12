Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbXBLOis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbXBLOis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964949AbXBLOis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:38:48 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:37632 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964942AbXBLOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:38:47 -0500
Subject: Re: [GIT PATCH] SCSI updates for 2.6.20
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200702121129.34359.eike-kernel@sf-tec.de>
References: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
	 <200702121129.34359.eike-kernel@sf-tec.de>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 08:38:40 -0600
Message-Id: <1171291120.3690.0.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 11:29 +0100, Rolf Eike Beer wrote:
> Am Sonntag, 11. Februar 2007 schrieb James Bottomley:
> > This is the accumulated SCSI tree for 2.6.20.  It is available at
> >
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> You once again have not included this two patches Andrew sent you on 20070602:
> 
> [patch 08/33] remove extra newline from info message

This one's waiting on Hannes to ack, since he's working in that driver

> [patch 09/33] Fix scsi/scsi_transport.h compile error

I did look at this one, but I can't find a configuration that will
induce a compile error like the header says.  It's pending further
investigation.

James


