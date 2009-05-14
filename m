Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZENTrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZENTrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZENTqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:46:49 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:25586 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZENTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:46:49 -0400
Date: Thu, 14 May 2009 15:46:29 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Janne Kulmala <janne.t.kulmala@tut.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
In-reply-to: <4A0855A5.8040109@tut.fi>
Message-id: <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
 <200905110226.50115.elendil@planet.nl>
 <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
 <4A0855A5.8040109@tut.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied (with ;; fixed:-)

sorry for causing the regression,
and thanks for quickly isolating it!

Len Brown, Intel Open Source Technology Center
