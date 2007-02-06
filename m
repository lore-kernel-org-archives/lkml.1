Return-Path: <linux-kernel-owner+w=401wt.eu-S965481AbXBFVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbXBFVXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXBFVXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:23:35 -0500
Received: from mail.macqel.be ([194.78.208.39]:24867 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965481AbXBFVXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:23:34 -0500
Date: Tue, 6 Feb 2007 22:23:32 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge
Message-ID: <20070206212332.GE2649@ingate.macqel.be>
References: <20070205195130.GB5206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205195130.GB5206@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 08:51:30PM +0100, Ondrej Zajicek wrote:
> This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> with most versions of S3 Trio and S3 Virge, on i386.
> It is tested both as compiled-in and module. It is against
> linux-2.6.20 .

I would like to test your patch, because I have such boards.
How would you suggest to test, because of course, If I loose my screen,
I won't be able to test further.

Currently my X server is configured for VESA.

Philippe
