Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbYDKPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbYDKPY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbYDKPYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:24:21 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54046 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbYDKPYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:24:21 -0400
Subject: Re: [PATCH bz #10388] doc: fix DMA-API function parameters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20080404092106.243b5dd2.randy.dunlap@oracle.com>
References: <20080404092106.243b5dd2.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 10:24:16 -0500
Message-Id: <1207927456.5066.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 09:21 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel bugzilla #10388.
> 
> DMA-API.txt has wrong argument type for some functions.
> It uses struct device but should use struct pci_dev.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>

James


