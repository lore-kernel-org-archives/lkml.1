Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZDXOtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZDXOtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDXOth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:49:37 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39511 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZDXOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:49:36 -0400
Date: Fri, 24 Apr 2009 10:49:20 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ACPI/hpet: prevent boot hang when hpet=force used on ICH-4M
In-reply-to: <20090424063734.GA21739@elte.hu>
Message-id: <alpine.LFD.2.00.0904241048450.10096@localhost.localdomain>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
 <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
 <20090424063734.GA21739@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://bugzilla.kernel.org/show_bug.cgi?id=13087
> 
> Nice fix! This moots the other half-quirk patch you wrote for hpet, 
> right?

Right.

thanks,
Len Brown, Intel Open Source Technology Center

