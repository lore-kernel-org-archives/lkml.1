Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZF3AXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZF3AXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZF3AW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:22:59 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44662 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZF3AW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:22:58 -0400
Date: Tue, 30 Jun 2009 10:23:00 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Rob Landley <rob@landley.net>
Cc: Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
Message-ID: <20090630002300.GE9451@bilbo.ozlabs.org>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <200906281033.09842.jk@ozlabs.org> <200906291834.07902.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200906291834.07902.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:34:06PM -0500, Rob Landley wrote:

> Cool!  Is there a reason it's hidden?  (Or at least not listed in either 
> vger.kernel.org's list info page

Because it's not hosted on vger :( ... I guess we're controll freaks! :D

>                                  or in the "Maling lists" page linked from 
> ozlabs.org's top level web page.)

Ahh this is becuase we're currently on the process of moving the lists to
"lists.ozlabs.org", there is an alias in place so the old address still works.
So at some level it's just bad timing :(

We'll do what we can to make this easier during the transition.

>                                    Just curious, I couldn't find it when I 
> looked in the obvious (to me) places.

Not to be flipant but it's in the MAINTAINERS file:

---
LINUX FOR POWERPC (32-BIT AND 64-BIT)
P:      Benjamin Herrenschmidt
M:      benh@kernel.crashing.org
P:      Paul Mackerras
M:      paulus@samba.org
W:      http://www.penguinppc.org/
L:      linuxppc-dev@ozlabs.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
S:      Supported
---
 
> P.S.  Yes I tried google: top hit for "linux powerpc list" is penguinppc.org, 
> which links to mailing lists on the right which is the ozlabs.org page that 
> doesn't list linuxppc-dev.  In fact the entire first page of google hits for 
> that search doesn't give a hint of the existence of that list, although some 
> of the later ones might if I clicked through more of them...

Rats, not really sure what we can do about that :(

Yours Tony
