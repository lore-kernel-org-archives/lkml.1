Return-Path: <linux-kernel-owner+w=401wt.eu-S1764590AbXJRLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764590AbXJRLwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXJRLwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:52:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51394 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbXJRLwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:52:10 -0400
Date: Thu, 18 Oct 2007 13:53:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-ID: <20071018115340.GC19539@uranus.ravnborg.org>
References: <200710090125.19089.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710090125.19089.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Prevent docproc from segfaulting when SRCTREE isn't set.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

Applied to kbuild.git (with Randy's style fixup).

	Sam
