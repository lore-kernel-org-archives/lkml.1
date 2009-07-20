Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZGTQdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZGTQdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZGTQdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:33:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53029 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbZGTQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:33:33 -0400
Date: Mon, 20 Jul 2009 12:33:07 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
In-Reply-To: <20090717221336.GA7336@merkur.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0907181236440.23110@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu> <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu>
 <20090717221336.GA7336@merkur.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009, Sam Ravnborg wrote:

> I do not expect Tejun's work to be included until next merge window.

Yes, but I expect the "sh" patch presumably to go in at the next merge 
window as well.  Since in this case the conflict was both patches making 
similar changes where Tejun's was more extensive, I figured I might as 
well save someone from having to resolve this useless merge conflict 
during the next merge window.

> It would be nice if we could queue up a lot of vmlinux.lds
> cleanup patches so they are ready for next merge window.
> But we should rely on the arch maintainers mostly - as you nicely
> have done for sh here.

Yes, I'm hoping to have vmlinux.lds cleanup patches for most architectures 
before the merge window starts, though as I am quite busy, I can't make 
any guarantees.

	-Tim Abbott


