Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbZJMSKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbZJMSKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760819AbZJMSKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:10:10 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:48861 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404AbZJMSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:10:08 -0400
Date: Tue, 13 Oct 2009 11:07:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] whci: fix type and format warnings
Message-Id: <20091013110734.56b0e027.randy.dunlap@oracle.com>
In-Reply-To: <4AD4BE19.8040005@csr.com>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
	<20091013100128.0f06d67c.randy.dunlap@oracle.com>
	<4AD4BE19.8040005@csr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AD4C24D.016E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 18:51:21 +0100 David Vrabel wrote:

> Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix format and type warnings in whci driver:
> 
> I'd prefer this fixed differently.  Those debug messages were left in by
> mistake.  Randy, you want to respin this or shall I?

You can do it.

Thanks.

---
~Randy
