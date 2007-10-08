Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbXJHSla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbXJHSla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbXJHSlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:41:04 -0400
Received: from mga06.intel.com ([134.134.136.21]:35892 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756909AbXJHSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:41:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,244,1188802800"; 
   d="scan'208";a="242256332"
Date: Mon, 8 Oct 2007 11:40:29 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071008184029.GA31906@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <25555.1191864285@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25555.1191864285@lwn.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 11:24:45AM -0600, Jonathan Corbet wrote:
> Last month, at the kernel summit, there was discussion of putting a
> Reviewed-by: tag onto patches to document the oversight they had
> received on their way into the mainline.  That tag has made an
> occasional appearance since then, but there has not yet been a
> discussion of what it really means.  So it has not yet brought a whole
> lot of value to the process.
> 
> As I was trying to sleep last night, it occurred to me that what we
> might need is an equivalent of the DCO for the Reviewed-by tag.  To that
> end, I dedicated a few minutes of my life to the following bit of text.
> It's really just meant to be a starting point for the discussion.  Is
> the following something close to what we understand Reviewed-by to mean? 
> 
> jon
> 
> 
> Reviewer's statement of oversight v0.01
> 
> By offering my Reviewed-by: tag, I state that:
> 
>  (a) I have carried out a technical review of this patch to evaluate its
>      appropriateness and readiness for inclusion into the mainline kernel. 
> 
>  (b) Any problems, concerns, or questions relating to the patch have been
>      communicated back to the submitter.  I am satisfied with how the
>      submitter has responded to my comments.
> 
>  (c) While there may (or may not) be things which could be improved with
>      this submission, I believe that it is, at this time, (1) a
>      worthwhile addition to the kernel, and (2) free of serious known
>      issues which would argue against its inclusion.

C-1 "worthwhile addition..." Probably shouldn't be part of this.  That's
what additional Signed off by ACK's provide.  I think reviewed by should
limit its scope to code correctness leaving the subjective "worthwhile"
statements are better expressed with other tags.

> 
>  (d) While I have reviewed the patch and believe it to be sound, I can not
>      (unless explicitly stated elsewhere) make any warranties or guarantees
>      that it will achieve its stated purpose or function properly in any
>      given situation.
> 
>  (e) I understand and agree that this project and the contribution are
>      public and that a record of the contribution (including my Reviewed-by
>      tag and any associated public communications) is maintained
>      indefinitely and may be redistributed consistent with this project or
>      the open source license(s) involved.
> -

I think this is a good thing to have, although recruiting reviews remains
an open issue.

I think it would be easier to recruit patch testers than reviewers
should a Tested-by: tag be considered as well?

--mgross
