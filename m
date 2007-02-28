Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbXB1UJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbXB1UJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXB1UJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:09:44 -0500
Received: from gw.goop.org ([64.81.55.164]:41588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXB1UJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:09:44 -0500
Message-ID: <45E5E183.6050809@goop.org>
Date: Wed, 28 Feb 2007 12:09:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap
 slot
References: <20070227081337.434798469@goop.org> <20070227081631.122933982@goop.org> <20070227101143.GC10827@elte.hu> <45E47E95.2060803@goop.org> <45E4D1B1.7030903@goop.org> <20070228083055.GA8866@elte.hu>
In-Reply-To: <20070228083055.GA8866@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> fair enough. Please rename it to FIX_PARAVIRT_BOOTUP - you can still 
> rely on it being available later on too, but we'd like to give everyone 
> the right fundamental idea about this: it's meant to be a limited, 
> inflexible interface for bootstrap only.
>   

Will do.

    J
