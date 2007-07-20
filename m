Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbXGTTKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbXGTTKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762634AbXGTTKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:10:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762581AbXGTTKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:10:07 -0400
Message-ID: <46A10882.10009@redhat.com>
Date: Fri, 20 Jul 2007 15:09:54 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>,
       "clameter@sgi.com" <clameter@sgi.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com>	 <20070531003012.302019683@sgi.com> <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com> <46A0E2A9.6000308@s5r6.in-berlin.de> <46A0E49A.3040302@s5r6.in-berlin.de>
In-Reply-To: <46A0E49A.3040302@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2007 12:36 PM, Stefan Richter wrote:
>>>> +config STABLE
>>>> +       bool "Stable kernel"
> 
> PS:  Imagine the headlines at Slashdot, CNET et al when this gets in.

I think this really should be called CONFIG_EXTRA_CHECKS.
It's a lot clearer what that means...

