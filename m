Return-Path: <linux-kernel-owner+w=401wt.eu-S1764131AbXFRRQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764131AbXFRRQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbXFRRQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:16:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbXFRRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:16:10 -0400
Date: Mon, 18 Jun 2007 10:09:05 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Dan Aloni <da-x@monatomic.org>, Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches
Message-ID: <20070618100905.7fc1176c@localhost.localdomain>
In-Reply-To: <46754400.2080101@googlemail.com>
References: <4675430B.2000304@googlemail.com>
	<46754400.2080101@googlemail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007 16:24:00 +0200
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc5
> with patches available.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> Memory management
> 
> Subject    : bug in i386 MTRR initialization
> References : http://lkml.org/lkml/2007/5/19/93
> Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
> Status     : patch available
> 
> 
> 
> Networking
> Subject    : commit 9093bbb2d96d0184f037cea9b4e952a44ebe7c32 broke the bonding driver
> References : http://lkml.org/lkml/2007/6/13/65
> Submitter  : Dan Aloni <da-x@monatomic.org>
> Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
> Status     : patch available
>              (I cannot find it in archives. Stephen, please resend the patch)
>

http://www.mail-archive.com/netdev@vger.kernel.org/msg40352.html

