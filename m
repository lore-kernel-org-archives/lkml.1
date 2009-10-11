Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZJKTxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZJKTxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZJKTxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:53:33 -0400
Received: from www.tglx.de ([62.245.132.106]:35399 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZJKTxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:53:32 -0400
Date: Sun, 11 Oct 2009 21:52:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
       infinipath@qlogic.com, Ralph Campbell <ralph.campbell@qlogic.com>
Subject: Re: infiniband BKL leftovers
In-Reply-To: <ada8wfhivdd.fsf@cisco.com>
Message-ID: <alpine.LFD.2.00.0910112151490.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain> <adad44tj090.fsf@cisco.com> <ada8wfhivdd.fsf@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Roland Dreier wrote:

> [Adding Ralph's direct email]
> 
> And the address in MAINTAINERS of infinipath@qlogic.com appears to be
> bouncing... so I think it's pretty safe to say that Qlogic doesn't care
> too much about the ipath driver any more.

Time to create drivers/bitrotting which serves the opposite purpose of
drivers/staging :) I have a huge list of candidates for that.

Thanks,

	tglx
