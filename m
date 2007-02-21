Return-Path: <linux-kernel-owner+w=401wt.eu-S1423181AbXBUWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423181AbXBUWOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423182AbXBUWOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:14:20 -0500
Received: from gw.goop.org ([64.81.55.164]:42932 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423181AbXBUWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:14:19 -0500
Message-ID: <45DCC438.3070409@goop.org>
Date: Wed, 21 Feb 2007 14:14:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.osdl.org, Chris Wright <chrisw@sous-sol.org>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 17/24] Xen-paravirt_ops: avoid having a bad selector in
 %gs during context switch
References: <20070221205254.169835700@goop.org> <20070221205323.770169136@goop.org> <200702212310.02218.ak@suse.de>
In-Reply-To: <200702212310.02218.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Sorry, but i don't really want that unconditionally in the context switch.
> Adding a paravirt ops for it would be also ugly. Can Xen be fixed?
>   

Yes.  I'm happy to drop this one.

    J
