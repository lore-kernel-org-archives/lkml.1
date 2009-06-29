Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZF2Vqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZF2Vqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF2Vqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:46:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZF2Vqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:46:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-system-of-record;
	b=ZAG/hl9jSZBYukE2ZyyZ9yQJ0/ooApaDTPADyYclOovyqCyef97lXh1f5RVQsnjnh
	FjOEijLHHhrVLRA5YS96g==
Date: Mon, 29 Jun 2009 14:46:10 -0700
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>, San Mehat <san@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       pierre@ossman.eu, Andrew Morton <akpm@osdl.org>
Subject: Re: MMC driver for HTC Dream
Message-ID: <20090629214610.GB16981@google.com>
References: <20090629214101.GA12043@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629214101.GA12043@elf.ucw.cz>
Organization: Google, Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pavel Machek <pavel@ucw.cz>]
> From: San Mehat <san@android.com>
> 
> MMC Driver for HTC Dream. I picked the code up from Google git trees,
> removed stuff not strictly neccessary, and did a bit of cleanups. It
> still works :-).

Hi Pavel,

I'm looping in San, who wrote the driver.  Thanks a ton for doing all
this work to help clean stuff up and push toward mainline.  Could you
include the original driver authors (the git history should show them
and often they're mentioned in an Author: line under the copyright/
license banners) on to: or cc: when you send out patches?  

I forwarded the original mail to San so he should have this patch
intact.

Thanks!

Brian

