Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbYBUMSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbYBUMSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbYBUMSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:18:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:38470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbYBUMSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:18:10 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc2
Date: Thu, 21 Feb 2008 07:17:16 -0500
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200802210357.08197.lenb@kernel.org> <20080221095431.GB26714@uranus.ravnborg.org>
In-Reply-To: <20080221095431.GB26714@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210717.17047.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 04:54, Sam Ravnborg wrote:
> On Thu, Feb 21, 2008 at 03:57:07AM -0500, Len Brown wrote:
> > Hi Linus,
> > 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > 
> > Fixes a pair of a boot regressions, and some churn mostly related
> > to some of the new thermal and thinkpad code that went into -rc1.
> > 
> > This will update the files shown below.
> 
> Hi Len.
> 
> Any specific reason the two section mismatch patches that
> I posted a few days ago are not included?
> If they are buggy or questionable please let me know.
> 
> I can resend if you like.

they're still in the test branch.

-Len
