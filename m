Return-Path: <linux-kernel-owner+w=401wt.eu-S935341AbYBHSIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341AbYBHSIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbYBHSAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:00:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039AbYBHSAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:00:40 -0500
Date: Fri, 8 Feb 2008 10:00:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags, one more time
In-Reply-To: <9525.1202489479@vena.lwn.net>
Message-ID: <alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
References: <9525.1202489479@vena.lwn.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Feb 2008, Jonathan Corbet wrote:
> +
> +These tags are:
> +
> +From: 	   	The original author of the patch.  This tag will ensure
> +		that credit is properly given when somebody other than the
> +		original author submits the patch.

"From:" is not a tag. It's a special marker at the *top* (and _only_ the 
top) of the email, which indicates authorship. It goes along with markers 
like "Date:" and "Subject:", and has nothing to do with the sign-off-like 
tags at the end.

		Linus
