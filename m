Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936Ab0A1QBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0A1QBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615Ab0A1QBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:01:08 -0500
Received: from khc.piap.pl ([195.187.100.11]:41545 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0A1QBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:01:08 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e>
Date: Thu, 28 Jan 2010 17:01:04 +0100
In-Reply-To: <1264597747.3607.29.camel@wall-e> (Stefani Seibold's message of
	"Wed, 27 Jan 2010 14:09:07 +0100")
Message-ID: <m3r5pagqwv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> The time of 80 characters punch card and terminals are over, so i would
> be a good thing to set the line length limit to 120. Every display today
> should be able handle this. 

I thought it's been already agreed that the limit is lifted altogether?
Not even the 132 that was considered by some people sane enough.

The other thing is that fine "code complexity", but I think checkpatch
can't check it ATM, can it?
-- 
Krzysztof Halasa
