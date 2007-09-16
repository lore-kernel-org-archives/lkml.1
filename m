Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbXIPHo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbXIPHo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXIPHoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:44:22 -0400
Received: from ozlabs.org ([203.10.76.45]:34481 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbXIPHoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:44:22 -0400
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under
	Virtualization menu
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Eremenko <al4321@gmail.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
	 <20070914091921.73007c5a.randy.dunlap@oracle.com>
	 <1189825504.7262.75.camel@localhost.localdomain>
	 <7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 16 Sep 2007 17:43:37 +1000
Message-Id: <1189928617.7262.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-15 at 11:49 +0300, Alexey Eremenko wrote:
> > We turn "Virtualization" into a menu, not a config option, since it's
> > actually only used as a menu.  Then we move lguest under that menu.
> 
> What about containerization bits ?
> 
> IPC_Namespaces, *_Namespaces  - I think we should evaluate adding them
> too to this menu.

Well, containerization deserves its own menu, but the question is does i
it belong under this menu?

Rusty.

