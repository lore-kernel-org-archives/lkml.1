Return-Path: <linux-kernel-owner+w=401wt.eu-S1945912AbXCBMyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945912AbXCBMyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 07:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945916AbXCBMyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 07:54:33 -0500
Received: from colin.muc.de ([193.149.48.1]:1175 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945912AbXCBMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 07:54:32 -0500
Date: 2 Mar 2007 13:54:28 +0100
Date: Fri, 2 Mar 2007 13:54:28 +0100
From: Andi Kleen <ak@muc.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Arp announce (for Xen)
Message-ID: <20070302125428.GA67405@muc.de>
References: <20070301232443.195603797@goop.org> <20070301232529.648076372@goop.org> <20070301164214.4a40bc59@freekitty> <45E7764A.7000100@goop.org> <20070301173030.754514ec@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301173030.754514ec@freekitty>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 05:30:30PM -0800, Stephen Hemminger wrote:
> What about implementing the unused arp_announce flag on the inetdevice?
> Something like the following.  Totally untested...
> 
> Looks like it either was there (and got removed) or was planned but
> never implemented.

Seems like the right solution to me (if it works)

-Andi
