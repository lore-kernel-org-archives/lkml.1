Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZFKQAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZFKQAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZFKP75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:59:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43091 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZFKP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:59:57 -0400
Date: Thu, 11 Jun 2009 16:59:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611155938.GB20460@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk> <20090611144735.GC2572@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611144735.GC2572@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 04:47:35PM +0200, Pavel Machek wrote:
> Well, usually Acked-by: and Reviewed-by: tags solve that, no?
> 
> If it has my acked-by: it is okay and can be applied. Otherwise I did
> not review it before and need to check it...

It would be nice if git pull messages included that information, but
they don't.  The only way to get at that from a pull message is to
pull the tree and then check it, or track down whatever random gitweb
URL corresponds with the tree and check it there.
