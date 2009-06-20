Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbZFTEQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbZFTEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 00:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbZFTEQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 00:16:49 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:48380 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZFTEQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 00:16:48 -0400
Date: Sat, 20 Jun 2009 00:16:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfi-devel@simplefirmware.org
Subject: Re: linux-next: Tree for June 19
In-reply-to: <20090619172622.05adb236.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0906200012200.4325@localhost.localdomain>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,
Please add the Simple Firmware Interface "sfi-test" branch to linux-next:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-test

A description of the project is on the SFI home page: http://simplefirmware.org/

Note: like ACPI's test branch, this branch will be occasionally re-based
as the patches in it evolve.

thanks,
Len Brown, Intel Open Source Technology Center

