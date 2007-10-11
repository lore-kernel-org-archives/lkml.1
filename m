Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXJKXwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXJKXwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXJKXwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:52:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35064 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbXJKXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:52:42 -0400
Date: Thu, 11 Oct 2007 16:52:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Add Documentation/RCU/00-Index
Message-ID: <20071011235238.GA8401@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200710111823.27396.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710111823.27396.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 06:23:27PM -0500, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Add Documentation/RCU/00-INDEX

Good addition!!!

Acked-by: Paul E. McKenney <paulmck@us.ibm.com>

> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  Documentation/RCU/00-INDEX |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> +++ hg/Documentation/RCU/00-INDEX	2007-10-11 18:17:26.000000000 -0500
> @@ -0,0 +1,22 @@
> +00-INDEX
> +	- This file
> +arrayRCU.txt
> +	- Using RCU to Protect Read-Mostly Arrays
> +checklist.txt
> +	- Review Checklist for RCU Patches
> +listRCU.txt
> +	- Using RCU to Protect Read-Mostly Linked Lists
> +NMI-RCU.txt
> +	- Using RCU to Protect Dynamic NMI Handlers
> +rcuref.txt
> +	- Reference-count design for elements of lists/arrays protected by RCU
> +rcu.txt
> +	- RCU Concepts
> +RTFP.txt
> +	- List of RCU papers (bibliography) going back to 1980.
> +torture.txt
> +	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
> +UP.txt
> +	- RCU on Uniprocessor Systems
> +whatisRCU.txt
> +	- What is RCU?
> 
> -- 
> "One of my most productive days was throwing away 1000 lines of code."
>   - Ken Thompson.
