Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZKWPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZKWPhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZKWPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:37:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:50206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZKWPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:37:24 -0500
Subject: Re: newidle balancing in NUMA domain?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123152931.GD19175@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258987059.6193.73.camel@marge.simson.net>
	 <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop>
	 <20091123152931.GD19175@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 16:37:27 +0100
Message-ID: <1258990647.4531.600.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> 
> > .32 is kind of closed, with us being at -rc8.
> 
> It's a bad regression though.

Still haven't heard what workload, what machine, by how-much, nor any
reproducer.

And again, -rc8 is really late.

