Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYD3PGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYD3PGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYD3PGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:06:09 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45304 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbYD3PGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Paul Jackson <pj@sgi.com>
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Date: Wed, 30 Apr 2008 09:06:06 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200804291459.56300.bjorn.helgaas@hp.com> <200804291500.39879.bjorn.helgaas@hp.com> <20080430030335.4d269a83.pj@sgi.com>
In-Reply-To: <20080430030335.4d269a83.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804300906.07364.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008 02:03:35 am Paul Jackson wrote:
> This patch reminded me that I should update the CPUSETS maintainers,
> which I will be sending in a separate patch shortly.
> 
> However, that in turn highlights one problem with updating several
> MAINTAINERS entries at once; it will almost surely collide with
> other ongoing updates to the MAINTAINERS file.  On that account,
> your proposal might not be worth the extra effort it would take to
> get merged ... I'm not sure.

Yes, that's a problem, and that's why I posted a filter to do the
bulk of the work.  It seems like the easiest way would be for Linus
to run the script and generate a patch at his end.  There are only
a handful of patches in -mm that touch MAINTAINERS, so it shouldn't
generate too many conflicts there.

Bjorn
