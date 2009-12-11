Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZLKKOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZLKKOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZLKKO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:14:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbZLKKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:14:27 -0500
Date: Fri, 11 Dec 2009 11:14:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: phoronix test,  openssl bad performance
Message-ID: <20091211101430.GQ18989@one.firstfloor.org>
References: <4B213ADD.6010200@gmail.com> <877hsumqpj.fsf@basil.nowhere.org> <4B2187F7.10301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2187F7.10301@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:44:55AM +0100, Xose Vazquez Perez wrote:
> On 12/10/2009 11:03 PM, Andi Kleen wrote:
> 
> > You should probably report that to Fedora through their bugzilla, 
> > it's unlikely to be a linux kernel problem.
> 
> I got *same* results with Fedora kernel as with a _clean_ 2.6.32-kernel.org
> Not a Fedora-kernel problem!

What I meant is that the kernel should not normally affect SSL performance.
OpenSSL (or whatever SSL package is used) is all user-space. So it needs 
to be looked at whoever maintains the SSL libraries first.

linux-kernel is really only for kernel problems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
