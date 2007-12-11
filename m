Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXLKSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXLKSOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXLKSOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:14:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:48365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLKSOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:14:33 -0500
To: Anas Nashif <nashif@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Intel Management Engine Interface
From: Andi Kleen <andi@firstfloor.org>
References: <475EC9C1.9080708@linux.intel.com>
Date: Tue, 11 Dec 2007 19:14:31 +0100
In-Reply-To: <475EC9C1.9080708@linux.intel.com> (Anas Nashif's message of "Tue\, 11 Dec 2007 12\:32\:49 -0500")
Message-ID: <p7363z5nlo8.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anas Nashif <nashif@linux.intel.com> writes:
>
> The Intel Management Engine Interface (aka HECI: Host Embedded 
> Controller Interface ) enables communication between the host OS and 
> the Management Engine firmware. MEI is bi-directional, and either the 
> host or Intel AMT firmware can initiate transactions.

Can you please expand a bit on who on the host OS would actually communicate
with the management engine? It looks like this driver just exports
an interface to user space. What user space would use it and for
what?

I would be definitely interested in a way to save oops information
away using this.  I remember you had a demo for this, is support
for that coming soon?

-Andi
