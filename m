Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYJGPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYJGPnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJGPnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:43:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYJGPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:43:33 -0400
Date: Tue, 7 Oct 2008 17:49:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, dipankar@in.ibm.com,
       tglx@linuxtronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081007154939.GN20740@one.firstfloor.org>
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007152629.GH6384@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm...  I chased out a number of these when doing rcutree.
> 
> This with classic RCU or preemptable RCU?

classic.

> Could you please send me your .config file?

http://halobates.de/defconfig64

-Andi

-- 
ak@linux.intel.com
