Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbYBTRc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbYBTRc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbYBTRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:31:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50018 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543AbYBTRby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:31:54 -0500
Date: Wed, 20 Feb 2008 18:32:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: XFS makefile-2.6 lives on
Message-ID: <20080220173204.GA19950@uranus.ravnborg.org>
References: <47BC5C48.2040509@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC5C48.2040509@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
	please do so.

It is too annoying to await next pull request from xfs.

	Sam

On Wed, Feb 20, 2008 at 11:58:48AM -0500, Jeff Garzik wrote:
> In current upstream, fs/xfs/Makefile-linux-2.6 is zero bytes, which 
> means 'make distclean' deletes, and git promptly (and properly) squawks 
> about a working tree/index difference.
> 
> Would somebody please delete this file?
> 
> Thanks,
> 
> 	Jeff
> 
> 
