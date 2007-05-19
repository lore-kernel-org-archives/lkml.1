Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbXESGSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbXESGSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXESGSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:18:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXESGSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:18:48 -0400
Message-ID: <464E96A1.60808@zytor.com>
Date: Fri, 18 May 2007 23:18:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: eugene@ns.armcci.am
CC: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
References: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am> <464DFBE0.5060904@redhat.com> <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am> <464E03C5.6040507@redhat.com> <Pine.LNX.4.64.0705190858590.29910@ns.armcci.am>
In-Reply-To: <Pine.LNX.4.64.0705190858590.29910@ns.armcci.am>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eugene@ns.armcci.am wrote:
> As I already told, there is no stepping 4 for Xeons on Intel site! So
> /proc/cpuinfo, dmidecode, x86info are all wrong.
> Moreover, x86info is too old and can't work with /sys fs.
> 
> Also Linux is poor on giving FSB and Memory frequency, which I need to
> be sure that memory timing is correct (SPD gives slower parameters then
> are on SDRAM labels :( ).

Linux doesn't give a hoot.  Setting up the memory is the BIOS' job.

I'm sure the authors of the tools can use a hand in updating them if
they are out of date.

	-hpa
