Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYB0SUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYB0SUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYB0SUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:20:25 -0500
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:41528 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754551AbYB0SUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:20:24 -0500
X-YMail-OSG: ltPzEEwVM1kfd1jnLQtR8IuYItLbLZDYColhjXvULJSOk2rygl5zppmS8WgMymukfoQXR4tk277QBhgAG2Z6s5YevFjA0koVhsSmcuFEZEyqEiTR2UoioGT2UsMbDwGV
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 27 Feb 2008 12:17:40 -0600
From: serge@hallyn.com
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: at program breaks with kernel 2.6.24
Message-ID: <20080227181740.GA14532@vino.hallyn.com>
References: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting BuraphaLinux Server (buraphalinuxserver@gmail.com):
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463669
> 
> I have the same problem - it is not debian specific.  Did the
> semantics of kill() change with the new kernel?  I thought as long as
> something is setuid, even with capability stuff around the setuid
> programs just get _all_ capabilities and would keep working.
> 
> I did a good search and found many people with the problem, but no
> solutions except going back to 2.6.23.x kernels.  I guess you'll flame
> me, but at least include a link to the solution too.

Why would we flame you?  I'll just apologize as I think it's my fault,
and ask you to please try the newest available kernel where I believe it
should be fixed.

thanks,
-serge
