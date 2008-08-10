Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYHJTlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYHJTlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYHJTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:40:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbYHJTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:40:51 -0400
Date: Sun, 10 Aug 2008 12:40:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>,
       "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@linuxfoundation.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "poswald@novell.com" <poswald@novell.com>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas - Add the dumy readl to force
 PCI flush
Message-Id: <20080810124011.b5e76eb9.akpm@linux-foundation.org>
In-Reply-To: <1218380616.3418.23.camel@localhost.localdomain>
References: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
	<4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
	<20080804174128.a0877c27.akpm@linux-foundation.org>
	<4B6A08C587958942AA3002690DD4F8C31AADD4C1@cosmail02.lsi.com>
	<1218380616.3418.23.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 10:03:36 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-08-05 at 06:27 -0600, Yang, Bo wrote:
> > Thanks Andrew.
> 
> So could we have the corrected patch, please ... at least the pci
> posting flush fix looks like a pure bug fix that's a rc candidate.
> 

I'll send them over now.
