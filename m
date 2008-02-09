Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYBIAEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYBIAEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbYBIAEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:04:34 -0500
Received: from mail.vyatta.com ([216.93.170.194]:55821 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbYBIAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:04:33 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.719
Date: Fri, 8 Feb 2008 16:04:27 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] KVM binary incompatiablity
Message-ID: <20080208160427.7594c837@extreme>
In-Reply-To: <47ACD614.2080000@codemonkey.ws>
References: <20080208113236.55b2ead1@extreme>
	<47ACD614.2080000@codemonkey.ws>
Organization: Vyatta
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 16:22:12 -0600
Anthony Liguori <anthony@codemonkey.ws> wrote:

> Stephen Hemminger wrote:
> > I notice that recent KVM is incompatiable with older versions.
> >
> > Using a KVM image created on 2.6.24 will crash on 2.6.25 (or
> > vice versa). It appears that Ubuntu Hardy has incorporated the 2.6.25
> > update even though it claims to be 2.6.24.
> >   
> 
> This isn't intentional.  What is the guest and how does it crash?
> 
> I've been using the same image for most of KVM's development life cycle 
> without having issues.
> 
> Regards,
> 
> Anthony Liguori
>
I'll see if I can get a backtrace, it isn't reliably reproducible.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
