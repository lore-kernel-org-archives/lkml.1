Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbYJ3RPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbYJ3RPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYJ3ROs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:14:48 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:41406 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ3ROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZFoqFMbUAQFDm08FqbHrkUUczoPxI+5HgumcTIxJIw9X3WVr7d9n+NKH5n7hktHIia
         9MbG/imzU6BAwYs+usQLCBqVDqdKYZEhTc7V79u3Dl1gyszw9KH/QJilPXHQ237c2HFU
         yjlIu8QC69yToezb4QobQldBujcBaMGaqs+l0=
Date: Thu, 30 Oct 2008 20:14:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC -tip] x86: nmi - add sensible names to nmi_watchdog boot
	param
Message-ID: <20081030171426.GD19888@localhost>
References: <20081030161646.GC19888@localhost> <20081030171052.GR771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030171052.GR771@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aristeu Rozanski - Thu, Oct 30, 2008 at 01:10:53PM -0400]
| > Add sensible names as "lapic" and "ioapic" to
| > nmi_watchdog boot parameter. Sometimes it is not
| > that easy to recall what exactly nmi_watchdog=1
| > does mean so we allow the using of symbolic names here.
| > 
| > Old numeric values remain valid.
| looks good to me, but you need to update the documentation as well.
| 
| -- 
| Aristeu
| 

Aristeu, maybe you could do it for me -- English is quite weak
side of me :)

		- Cyrill -
