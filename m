Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZCFJnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZCFJnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZCFJnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:43:24 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:33338 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZCFJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HRFGyf8rpo4B+QndKVfIjGviAQxUnAZIY2+c6f/IyJIGFivcVInwKCXfOfcGCCatOo
         vuuu3JUV6HjbVKRmO5uQh8adZEbs5It+tXupK7vFz1LHK0H9NDFSDmDHYwwaBEC+T9Jf
         k1/mfyoE+Qe24w9QH1Ygvp6ENqobIw4SrKcgE=
Date: Fri, 6 Mar 2009 01:43:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090306094312.GB24864@dtor-d630.eng.vmware.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090301144018.GA23581@frodo> <20090304090026.GC7394@dtor-d630.eng.vmware.com> <200903051554.40655.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903051554.40655.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:54:40PM -0800, David Brownell wrote:
> On Wednesday 04 March 2009, Dmitry Torokhov wrote:
> > Cool, I will keep it in my tree pending the threaded IRQ issue
> > resolution.
> 
> Speaking of which ... I'd like to confirm that you
> already have the twl4030_keypad.c driver in your tree.
> 
> That was (re) submitted via linux-input on 6-Feb, after
> addressing feedback from the previous version (and cc'd to
> the OMAP list), but I've not heard anything ...
> 
> http://marc.info/?l=linux-omap&m=123391069411717&w=2
> 
> I don't know of a good linux-input archive or I'd
> reference the post from there.
> 
> 

Yep, I have it now. Thanks David.

-- 
Dmitry
