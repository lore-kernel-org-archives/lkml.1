Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbXHASCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbXHASCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765667AbXHASB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:01:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765320AbXHASB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:01:56 -0400
Date: Wed, 1 Aug 2007 20:01:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Hans-Peter Jansen <hpj@urpla.net>
cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>, linux-fsdevel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
In-Reply-To: <200708011200.44093.hpj@urpla.net>
Message-ID: <Pine.LNX.4.64.0708012000420.26668@fbirervta.pbzchgretzou.qr>
References: <20070730161323.100048969@weierstrass.suse.de>
 <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de>
 <200708011200.44093.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1 2007 12:00, Hans-Peter Jansen wrote:
>
>*) The amount of administration work of any (necessary, unfortunately) 
>VMware XP instance running on top of those diskless clients excels that of 
>all diskless clients by an order of magnitude.

Hardly :)
Install XP, snapshot it when done. Copy .vmdk to 'all' machines.
On security upgrades, revert to snapshot (well - if the workflow allows it),
install, snapshot again. Etc.
Work: 1 1/2.


	Jan
-- 
