Return-Path: <linux-kernel-owner+w=401wt.eu-S1765463AbYCDVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765463AbYCDVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYCDVCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:02:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50841 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbYCDVB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:01:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CDB8BB.9020909@s5r6.in-berlin.de>
Date: Tue, 04 Mar 2008 22:01:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sam Ravnborg <sam@ravnborg.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 4
References: <20080304223947.375be10b.sfr@canb.auug.org.au>
In-Reply-To: <20080304223947.375be10b.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> There were three minor merge problems.

One of them is tests.git's lib/Kconfig.debug.  linux1394-2.6.git's 
commit 523a65f1a7a339e528ca6d6d808516fe195fde03 apparently is the one 
causing it.

Stephen, should one of me and Sam adjust his -next branch?  (This kind 
of conflict will be trivially avoided in the merge window; so resolving 
it now would mainly mean one manual(?) step less for Stephen.)
-- 
Stefan Richter
-=====-==--- --== --=--
http://arcgraph.de/sr/
