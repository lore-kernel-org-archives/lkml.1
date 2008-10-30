Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYJ3Rnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYJ3Rnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYJ3RnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:43:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:49740 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbYJ3RnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XNsBfetGLrNcunb3FVhSVYoW1zgNp8L2nnzAhWFYlFVCFcl82J9vNiwwqQmBkirQaN
         /E1EqXCa3moeO0S6DjD+GJt5S8EbVRAp/BFsd16q54f/BYFUo1DgrPNliUmJs4/Himz3
         LGQqgQfaKVnrg2O7yLdUT3C8af5D+XVU1p/b4=
Date: Thu, 30 Oct 2008 20:43:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC -tip] x86: nmi - add sensible names to nmi_watchdog boot
	param
Message-ID: <20081030174307.GE19888@localhost>
References: <20081030161646.GC19888@localhost> <20081030171052.GR771@redhat.com> <20081030171426.GD19888@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030171426.GD19888@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Oct 30, 2008 at 08:14:26PM +0300]
| [Aristeu Rozanski - Thu, Oct 30, 2008 at 01:10:53PM -0400]
| | > Add sensible names as "lapic" and "ioapic" to
| | > nmi_watchdog boot parameter. Sometimes it is not
| | > that easy to recall what exactly nmi_watchdog=1
| | > does mean so we allow the using of symbolic names here.
| | > 
| | > Old numeric values remain valid.
| | looks good to me, but you need to update the documentation as well.
| | 
| | -- 
| | Aristeu
| | 
| 
| Aristeu, maybe you could do it for me -- English is quite weak
| side of me :)
| 
| 		- Cyrill -

I think I'd better wait 'till your patch (for nmi_watchdog.txt)
applied. It allows me to just write a few words so it would be pushed
on top of _all_ nmi related changes these days (without interdiff).

		- Cyrill -
