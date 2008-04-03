Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYDCCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYDCCli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbYDCClU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:41:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43343 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760683AbYDCClU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:41:20 -0400
Date: Thu, 3 Apr 2008 03:41:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080403024117.GZ9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:50:20PM -0700, Linus Torvalds wrote:

> > BTW, what happened with sparse.git?
> 
> Yeah, we do seem to have lost a maintainer.

Have we?  I've seen Josh on sparse list quite recently, IIRC...
Yes - http://marc.info/?l=linux-sparse&m=120716477203477 just
yesterday...

Josh, do you have any pending patches?  I can just start a branch in
my tree, of course, but I'd rather deal with merge headache earlier
than later...
