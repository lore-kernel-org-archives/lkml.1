Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYCMRuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYCMRuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYCMRui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:50:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:47078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559AbYCMRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:50:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Date: Thu, 13 Mar 2008 13:49:27 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200803130214.36861.lenb@kernel.org> <20080312234516.bb079cc5.akpm@linux-foundation.org> <20080313125016.GZ7365@v2.random>
In-Reply-To: <20080313125016.GZ7365@v2.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131349.27964.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrea Arcangeli wrote:
> On Wed, Mar 12, 2008 at 11:45:16PM -0700, Andrew Morton wrote:
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch
> > 
> >   Hopeully fix a regression which Andrea Arcangeli hit.  Although I'm not sure
> >   that he has confirmed that this revert actually works?

Thanks for the reply, Andrea,

Does your system still fail running the latest ACPI release patch?

You can get it here:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

or check out Linus' top of tree and apply the plain patch:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc5.diff.gz

If no, does applying
http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch
still fix the issue?

thanks,
-Len
