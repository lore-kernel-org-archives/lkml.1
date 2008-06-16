Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYFPUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYFPUlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYFPUll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:41:41 -0400
Received: from gw.goop.org ([64.81.55.164]:55797 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYFPUlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:41:40 -0400
Message-ID: <4856CFD9.2060301@goop.org>
Date: Mon, 16 Jun 2008 13:40:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 13 (XEN)
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080613101316.1c228fe7.randy.dunlap@oracle.com> <4852F1C8.7060904@goop.org> <20080614203109.GH20851@kernel.dk> <4854B284.7030709@goop.org> <20080616193057.GA20851@kernel.dk>
In-Reply-To: <20080616193057.GA20851@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Thanks, I just folded it in with the existing patch to avoid breakage.
> That one doesn't have an ack from you though, so if you have done a full
> review of the x86 bits, I'd appreciate an ack on those from you :-)
>   

I've been testing it without problems, at least under Xen.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J

