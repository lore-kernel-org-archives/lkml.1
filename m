Return-Path: <linux-kernel-owner+w=401wt.eu-S934313AbYAaN7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbYAaN7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766010AbYAaN7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:59:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46276 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764705AbYAaN7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:59:39 -0500
Date: Thu, 31 Jan 2008 19:32:23 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel BUG while bootup
Message-ID: <20080131140223.GA6568@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
References: <20080122135800.GA6084@in.ibm.com> <20080122155329.GA30119@elte.hu> <20080128145722.GB25517@in.ibm.com> <20080128151300.GB12205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128151300.GB12205@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 04:13:00PM +0100, Ingo Molnar wrote:
> 
> * Sudhir Kumar <skumar@linux.vnet.ibm.com> wrote:
> 
> > I applied all the hot fixes patches but still the bug is there. (crash 
> > at early boot).
> > 
> > As I replied your earlier mail in which the patch sent by you does not 
> > apply (reverse). can you please look into the problem ?
> 
> could you test latest x86.git:
> 
>    http://redhat.com/~mingo/x86.git/README
> 
> does that crash too?

Sorry , unable to do that as the instrunctions at above location
do not work.
Something else I can try ?
> 
> 	Ingo
