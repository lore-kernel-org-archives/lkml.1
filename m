Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYBNPZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYBNPZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYBNPZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:25:18 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:63611 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYBNPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:25:15 -0500
Subject: Re: linux-next: first tree
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20080215020019.f7cb5895.sfr@canb.auug.org.au>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	 <200802141545.56488.rjw@sisk.pl>
	 <20080215020019.f7cb5895.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 14 Feb 2008 16:25:09 +0100
Message-Id: <1203002709.1044.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 02:00 +1100, Stephen Rothwell wrote:
> I would prefer that the trees be added by the subsystem maintainers and
> they can tell me which branch represents their expectations for the next
> kernel release (in this case 2.6.26). But thanks, hopefully you will have
> prodded them along. :-)

For the s390 architecture please use the "features" branch of git390:

git://git390.osdl.marist.edu/pub/scm/linux-2.6.git features

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


