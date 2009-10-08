Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbZJHQ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbZJHQ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbZJHQ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:26:43 -0400
Received: from trinity.develer.com ([83.149.158.210]:47033 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbZJHQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:26:42 -0400
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: Harri Olin <harri.olin@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
In-Reply-To: <1254852272.1471.172.camel@giskard>
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
	 <4ACB3741.2030101@gmail.com>  <1254852272.1471.172.camel@giskard>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Thu, 08 Oct 2009 12:26:00 -0400
Message-Id: <1255019160.30440.666.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 06-10-2009 a las 14:04 -0400, Bernie Innocenti escribió:
> > I have heard same thing happened with same kind of configuration, using 
> > Supermicro H8DME-2 motherboard, Opteron 2378 CPU.
> >
> >Even the controllers were on same slots.
> 
> Close.  Mine is a Supermicro H8DM8-2 with 2x Opteron 2374 HE CPU.

I was wrong (the BIOS DMI block is wrong).  The motherboard is labeled
as H8DME-2.

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

