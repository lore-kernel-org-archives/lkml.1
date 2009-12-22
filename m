Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLVM1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLVM1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZLVM07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:26:59 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:48006 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZLVM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:26:58 -0500
Message-ID: <4B30BAE0.5040700@csr.com>
Date: Tue, 22 Dec 2009 12:26:08 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Peter Huewe <peterhuewe@gmx.de>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Fix entry for uwb to include subdirectories
References: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de> <1261473735.1895.22.camel@Joe-Laptop.home>
In-Reply-To: <1261473735.1895.22.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2009 12:26:08.0829 (UTC) FILETIME=[F099AED0:01CA8301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2009-12-22 at 10:05 +0100, Peter Huewe wrote:
>> This little patch removes the asterisk wildcard, in order to get the uwb
>> maintainer when using get_maintainer.pl on anyfiles in the
>> subdirectories of uwb.
> 
> Is this correct?
> Does David Vrabel maintain drivers/uwb/i1480/ ?

Yes, it's basically obsolete hardware that Intel no longer develops
which is why it doesn't see many changes.  I'd just delete it except
there's a few people actually using it.

Neither the UWB or WLP maintainer entries are completely correct.  I'll
fix them up.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
