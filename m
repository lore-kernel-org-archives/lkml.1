Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0BPMaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:30:06 -0500
Received: from reaktio.net ([194.89.68.22]:54364 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0BPMaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:30:01 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2010 07:30:00 EST
Date: Tue, 16 Feb 2010 14:23:55 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Red Hat Enterprise Linux 5 (Tikanga) discussion mailing-list" 
	<rhelv5-list@redhat.com>
Cc: ia64dave@gmail.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com,
       ia64 Fedora Core Development <fedora-ia64-list@redhat.com>,
       Xen User-List <xen-users@lists.xensource.com>,
       xen-ia64-devel@lists.xensource.com
Subject: Re: [rhelv5-list] Itanium support ...
Message-ID: <20100216122355.GD2861@reaktio.net>
References: <96b40cab1001151415k2cce0a95idea5fa9a7eca32b3@mail.gmail.com> <6b75ae111001160533l1913f4c3h2f1a00dd7c803db5@mail.gmail.com> <96b40cab1002160350l42ea51fcqb552769b8dea539e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96b40cab1002160350l42ea51fcqb552769b8dea539e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 12:50:46PM +0100, Zoran Popovi? wrote:
>    The problem is they won't start dying, they were made not to - it was
>    meant to support what (mission) critical business is ... but I am not here
>    for that.
> 
>    I would like to hear, people, what do you think the future of commercial
>    linux distros on Itanium is one hand, and on the other - what is the
>    future of Xen in commercial distros ?
>    Is Xen going to be supported on Suse on Itanium in future ?
>    What #$%&! is going on ?
>

RHEL5 fully supports Xen, so Redhat will support Xen at least until 2014,
which is when RHEL5 goes EOL.

atm it looks like RHEL6 won't have Xen (dom0) included. RHEL6 will run as Xen domU (guest).

Novell SLES11 ships with Xen, and they seem to be actively working with Xen,
so I expect Novell continues to ship Xen in future products.
 
-- Pasi

