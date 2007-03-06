Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXCFTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXCFTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXCFTqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:46:34 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53724 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXCFTqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:46:32 -0500
Date: Tue, 6 Mar 2007 11:46:12 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306194612.GG19575@sequoia.sous-sol.org>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306085222.GA17002@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> yes - but de-facto contradicted by the Xen paravirt_ops patches sent to 
> lkml ;)

There's no intrinsic value to the Xen on VMI approach that's superior
to Xen on pv_ops (not to mention the complications that it causes).

What are you driving at?  You seem to be arguing that abstractions
are bad unless done via ABI's.  ACPI....

thanks,
-chris
