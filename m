Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbXJHRfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbXJHRfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXJHRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:35:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35614 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXJHRfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:35:36 -0400
Date: Mon, 8 Oct 2007 19:37:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071008173706.GA12026@uranus.ravnborg.org>
References: <25555.1191864285@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25555.1191864285@lwn.net>
User-Agent: Mutt/1.4.2.1i
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

snip...

Or maybe we need something much less formal that explain the purpose of the
four tags we use:

Signed-of-by:
Acked-by:
Reviewed-by:
Cc:
Tested-by:

OK - make it five then. I continously to see people mixing up especially
Acked-by: and Signed-of-by: both here at lkml but especially at the
arm-kernel list (the only other Linux dev list I follow atm). I do
beleive we see similar pattern in the other linux-dev lists where
people are confused by these tags and need a short two line summery for 
each of them.

	Sam
