Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZJMSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZJMSBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbZJMSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:01:22 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:41081 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZJMSBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:01:21 -0400
Message-ID: <4AD4BE19.8040005@csr.com>
Date: Tue, 13 Oct 2009 18:51:21 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] whci: fix type and format warnings
References: <20091013162312.8b93998b.sfr@canb.auug.org.au> <20091013100128.0f06d67c.randy.dunlap@oracle.com>
In-Reply-To: <20091013100128.0f06d67c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2009 17:51:21.0896 (UTC) FILETIME=[C660EA80:01CA4C2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix format and type warnings in whci driver:

I'd prefer this fixed differently.  Those debug messages were left in by
mistake.  Randy, you want to respin this or shall I?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
