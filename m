Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbYLAGCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbYLAGCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAGCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:02:25 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:61533 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYLAGCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:02:24 -0500
Date: Mon, 01 Dec 2008 01:02:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [RFC PATCH v2] create drivers/platform/x86/ from drivers/misc/
In-reply-to: <20081129073816.GB8351@uranus.ravnborg.org>
X-X-Sender: lenb@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812010053100.3314@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
 <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain>
 <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain>
 <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain>
 <20081128223533.GA5175@uranus.ravnborg.org>
 <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain>
 <20081129073816.GB8351@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, Henrique,
I've responded to your feedback in v2, which follows.

Ingo,
this version does not touch arch/x86/

thanks,
-Len


