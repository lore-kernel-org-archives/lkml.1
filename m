Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbXJWTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbXJWTfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJWTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:35:28 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45994 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbXJWTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:35:27 -0400
Date: Tue, 23 Oct 2007 15:35:26 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-ID: <20071023193526.GY4000@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com> <20071022114001.40470c15.akpm@linux-foundation.org> <20071023150429.GK4003@csclub.uwaterloo.ca> <20071023092333.39982483@laptopd505.fenrus.org> <20071023180547.GL4003@csclub.uwaterloo.ca> <adar6jl6685.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6jl6685.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 11:22:50AM -0700, Roland Dreier wrote:
> It's not a hard experiment to do.
> 
> The answer is:
> 
>     warning: suggest parentheses around assignment used as truth value

A warning is not an error.  It won't abort the compile.

The warning (which I don't remember gcc doing in the past) is a nice
idea though.

--
Len Sorensen
