Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbYBFGdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbYBFGdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYBFGdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:33:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:35848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYBFGdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:33:42 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Wed, 6 Feb 2008 01:33:25 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <200802052058.50663.lenb@kernel.org> <20080206024349.GA10883@suse.de>
In-Reply-To: <20080206024349.GA10883@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060133.25863.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply, Greg.

If these counters are not always available by default, then
I've lost most of their value for supporting systems in the field.

Plus, I think I can live with just the individual sysfs files,
given Bjorn's "grep . *" tip.

So if I follow the rules, do you think it is okay to put
these stats in sysfs?  In the hopes the answer is "yes",
I'll reply with a refreshed patch

cheers,
-Len
