Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbXFEXBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbXFEXBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbXFEXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:00:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822AbXFEXAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:00:50 -0400
Message-ID: <4665EB01.5040508@redhat.com>
Date: Tue, 05 Jun 2007 19:00:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH TRIVIAL] icom whitespace cleanups
References: <4665D3EC.60404@redhat.com> <18021.55632.359206.105260@cargo.ozlabs.ibm.com>
In-Reply-To: <18021.55632.359206.105260@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Chris Snook writes:
> 
>> Clean up whitespace and comments in drivers/serial/icom.c
> 
> These changes seem totally unnecessary, as the existing indentation is
> according to a commonly-accepted style and is quite reasonable:

There are actually a few different indentation styles used inconsistently 
throughout, which I personally find annoying, and there's lots of whitespace 
damage.  If I've really overstepped the bounds, I'll resubmit a somewhat smaller 
patch, but I'm inclined to make it look pretty while I've got the hood up.

> Also you don't seem to have cc'd the driver author.

Can't find any contact info.  Care to enlighten me?

	-- Chris
