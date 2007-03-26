Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXCZLxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXCZLxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXCZLxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:53:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49932 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXCZLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:53:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 0/21] MSI rework
References: <1174560686.307511.956605711793.qpush@cradle>
	<m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	<20070322190834.GA14802@kroah.com>
	<1174600936.10836.53.camel@localhost.localdomain>
	<20070322220837.GD20713@kroah.com>
	<1174623443.5401.21.camel@concordia.ozlabs.ibm.com>
	<m1ps705ka1.fsf@ebiederm.dsl.xmission.com>
	<1174892991.4782.11.camel@concordia.ozlabs.ibm.com>
Date: Mon, 26 Mar 2007 05:52:26 -0600
In-Reply-To: <1174892991.4782.11.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Mon, 26 Mar 2007 17:09:51 +1000")
Message-ID: <m13b3s2pdx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> OK. For starters, do you want to review the first eleven as I've sent
> them already, that saves spamming everyone again.
>
> If you're OK with those eleven, then I'll send the remaining 10 or so
> later in the week, broken up into (sort-of) functional groups.

Sounds like a decent plan.  At a quick glance there is a reasonable chance
I'm going to run into issues with patch 9 or 10.  Let me get as far as I can
with the acks and then we can see where we go with the next round of patches.

Eric
