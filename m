Return-Path: <linux-kernel-owner+w=401wt.eu-S1762341AbXFZX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341AbXFZX0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXFZXNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:13:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33263 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389AbXFZXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:13:05 -0400
Date: Tue, 26 Jun 2007 16:14:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Torsten Duwe <duwe@lst.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: EDD build error
Message-Id: <20070626161459.5f947837.randy.dunlap@oracle.com>
In-Reply-To: <200706270044.02117.duwe@lst.de>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<200706270016.44999.duwe@lst.de>
	<20070626153336.e7156b7e.randy.dunlap@oracle.com>
	<200706270044.02117.duwe@lst.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 00:44:02 +0200 Torsten Duwe wrote:

> On Wednesday 27 June 2007, Randy Dunlap wrote:
> >
> > From original email:
> > (This is in 2.6.22-rc4-mm2 FWIW.)
> 
> Sorry. This one should be better.
> I've moved the edd_info, to avoid the -Wunused.

Yes, that one works fine.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
