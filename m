Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYGYWLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYGYWLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYGYWL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:11:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYGYWLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:11:25 -0400
Date: Fri, 25 Jul 2008 18:11:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: srostedt@redhat.com, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Make output nicely spaced for up to 999 cpus
Message-ID: <20080725221124.GA837@goodmis.org>
References: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:15:01PM +1000, Michael Ellerman wrote:
> 
> Currently some of the ftrace output goes skewiff if you have more
> than 9 cpus, and some if you have more than 99.
> 
> Twiddle with the headers and format strings to make up to 999 cpus
> display without causing spacing problems.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

