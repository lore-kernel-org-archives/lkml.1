Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYDLFPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYDLFPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYDLFO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:14:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbYDLFO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:14:58 -0400
Date: Fri, 11 Apr 2008 22:14:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
Message-Id: <20080411221448.22b69ff5.akpm@linux-foundation.org>
In-Reply-To: <m37if4oz1g.fsf@maximus.localdomain>
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain>
	<m37if4oz1g.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 23:35:23 +0200 Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Hi,
> 
> I wrote:
> 
> > So are we leaving the generic-HDLC+PPP in broken state for 2.6.25,
> > aren't we?
> >
> > If we do, perhaps a "|| BROKEN" in drivers/net/wan/Kconfig would make
> > sense?
> 
> Linus just made 2.6.25-rclast (I hope), I understand 2.6.25 will have
> broken drivers/net/wan/hdlc_ppp, any chance to apply the temporary
> Kconfig ("depends on BROKEN") patch?
> 
> Would you like me to resend it?

It never hurts to resend.  It was 6000 patches ago and my mind is a blank.

