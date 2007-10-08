Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbXJHTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbXJHTFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJHTFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:05:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50910 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXJHTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:05:20 -0400
Date: Mon, 8 Oct 2007 20:05:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: mgross@linux.intel.com, Jonathan Corbet <corbet@lwn.net>,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071008190515.GU8181@ftp.linux.org.uk>
References: <25555.1191864285@lwn.net> <20071008184029.GA31906@linux.intel.com> <470A7C91.3010503@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470A7C91.3010503@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 08:53:05PM +0200, Stefan Richter wrote:
> Mark Gross wrote:
> > On Mon, Oct 08, 2007 at 11:24:45AM -0600, Jonathan Corbet wrote:
> >>  (a) I have carried out a technical review of this patch to evaluate its
> >>      appropriateness and readiness for inclusion into the mainline kernel. 
> [...]
> >>  (c) While there may (or may not) be things which could be improved with
> >>      this submission, I believe that it is, at this time, (1) a
> >>      worthwhile addition to the kernel, and (2) free of serious known
> >>      issues which would argue against its inclusion.
> > 
> > C-1 "worthwhile addition..." Probably shouldn't be part of this.  That's
> > what additional Signed off by ACK's provide.  I think reviewed by should
> > limit its scope to code correctness leaving the subjective "worthwhile"
> > statements are better expressed with other tags.
> 
> A patch which is not "worthwhile" is also not "appropriate".  Mere
> correctness in a mathematical sense is not enough as technical review
> criterion.

Yes, but there's also such thing as "worthwhile removal".
