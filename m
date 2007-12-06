Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXLFTgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXLFTgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLFTgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:36:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXLFTgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:36:24 -0500
Date: Thu, 6 Dec 2007 14:36:21 -0500
From: Alan Cox <alan@redhat.com>
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com
Subject: Re: [PATCH] Enabling the echo of ctrl-C (and the like)
Message-ID: <20071206193621.GA21382@devserv.devel.redhat.com>
References: <47584BD3.8080306@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47584BD3.8080306@skyrush.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 12:21:55PM -0700, Joe Peterson wrote:
> I've used over the years as well.  Bringing this to Linux also seems
> like a good way to make it yet more compliant with standard unix-like
> behavior.
> 
> The fix is pretty trivial.  Let me know if you think this is a candidate
> for inclusion in the kernel.

If it matches other platforms and doesn't seem to break anything then I
don't see a problem. 

