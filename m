Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXKAWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXKAWZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXKAWZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:25:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53494 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbXKAWZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:25:24 -0400
Date: Thu, 1 Nov 2007 15:23:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] debloat aic7xxx and aic79xx drivers
Message-Id: <20071101152328.be2a4515.randy.dunlap@oracle.com>
In-Reply-To: <20071101221604.GB19914@parisc-linux.org>
References: <200710141558.27156.vda.linux@googlemail.com>
	<200710141600.10468.vda.linux@googlemail.com>
	<200710141601.08946.vda.linux@googlemail.com>
	<200710141602.16283.vda.linux@googlemail.com>
	<20071101221604.GB19914@parisc-linux.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 16:16:04 -0600 Matthew Wilcox wrote:

> On Sun, Oct 14, 2007 at 04:02:15PM +0100, Denys Vlasenko wrote:
> > Adds more consts
> 
> error: patch failed: drivers/scsi/aic7xxx/aic79xx.h:1328
> error: drivers/scsi/aic7xxx/aic79xx.h: patch does not apply
> error: patch failed: drivers/scsi/aic7xxx/aic7xxx.h:1145
> error: drivers/scsi/aic7xxx/aic7xxx.h: patch does not apply

when attempting to apply to scsi-misc or linus-git or ... ?

Thanks,
---
~Randy
