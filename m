Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbYCEHmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbYCEHmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbYCEHle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:41:34 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35051 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbYCEHld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:41:33 -0500
Date: Wed, 5 Mar 2008 08:41:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 4
Message-ID: <20080305074148.GB15400@uranus.ravnborg.org>
References: <20080304223947.375be10b.sfr@canb.auug.org.au> <47CDB8BB.9020909@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDB8BB.9020909@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:01:47PM +0100, Stefan Richter wrote:
> Stephen Rothwell wrote:
> >git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> >There were three minor merge problems.
> 
> One of them is tests.git's lib/Kconfig.debug.  linux1394-2.6.git's 
> commit 523a65f1a7a339e528ca6d6d808516fe195fde03 apparently is the one 
> causing it.

I think I have a patch for this somewhere.
But I do not have time to look into this until earliest in the weekend.
And the test.git tree is down on my TODO list as I have pending issues in kbuild.git.

	Sam
