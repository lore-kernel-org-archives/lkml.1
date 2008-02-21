Return-Path: <linux-kernel-owner+w=401wt.eu-S1764496AbYBUJyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764496AbYBUJyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYBUJyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:54:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34296 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYBUJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:54:38 -0500
Date: Thu, 21 Feb 2008 10:54:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc2
Message-ID: <20080221095431.GB26714@uranus.ravnborg.org>
References: <200802210357.08197.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802210357.08197.lenb@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 03:57:07AM -0500, Len Brown wrote:
> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> Fixes a pair of a boot regressions, and some churn mostly related
> to some of the new thermal and thinkpad code that went into -rc1.
> 
> This will update the files shown below.

Hi Len.

Any specific reason the two section mismatch patches that
I posted a few days ago are not included?
If they are buggy or questionable please let me know.

I can resend if you like.

	Sam
