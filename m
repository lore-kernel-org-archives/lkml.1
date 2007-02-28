Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXB1QDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXB1QDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXB1QDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:03:12 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:39090 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXB1QDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:03:11 -0500
X-Greylist: delayed 5103 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 11:03:07 EST
Message-ID: <45E593C2.6020004@freescale.com>
Date: Wed, 28 Feb 2007 08:37:54 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathiasen, Torben wrote:

> Assuming QE has 4 entries, I would expect CPM to be the same. But we
> need verification of that. If it needs 6, we are in more trouble.

The QE can have up to 8, actually, but I'm willing to limit the driver 
to 4.
