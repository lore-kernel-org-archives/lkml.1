Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXLJPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXLJPZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXLJPZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:25:33 -0500
Received: from baron.borf.com ([65.14.39.133]:27553 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbXLJPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:25:32 -0500
Date: Mon, 10 Dec 2007 10:23:17 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jon Nelson <jnelson@jamponi.net>, jnelson-kernel-bugzilla@jamponi.net,
       bugme-daemon@bugzilla.kernel.org, nickpiggin@yahoo.com.au,
       clameter@sgi.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       a.p.zijlstra@chello.nl
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-ID: <20071210152317.GA943@coraid.com>
References: <20071201122302.10dd9c44.akpm@linux-foundation.org> <20071203162137.GB25251@coraid.com> <20071203113459.d36c1a01.akpm@linux-foundation.org> <20071203210005.GB27094@coraid.com> <20071203213837.GE27094@coraid.com> <20071203144722.4188f476.akpm@linux-foundation.org> <20071203151349.0ebf497c.akpm@linux-foundation.org> <20071203234228.GG27094@coraid.com> <cccedfc60712081459u764de23ck953750fbdb391d16@mail.gmail.com> <20071208195015.b4b22e35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208195015.b4b22e35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 07:50:15PM -0800, Andrew Morton wrote:
> On Sat, 8 Dec 2007 16:59:30 -0600 "Jon Nelson" <jnelson@jamponi.net> wrote:
> 
> > I can confirm that 2.6.24rc4 with the (second) patch works fine.
> 
> OK, thanks.
> 
> We haven't heard back from Ed yet.   I'll sit on this for a few more days.

Sorry, yes, the second patch works well for me in testing.  I had some
initial concerns that were unfounded.

-- 
  Ed L Cashin <ecashin@coraid.com>
