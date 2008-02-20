Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbYBTWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbYBTWvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYBTWvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:51:22 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42388 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYBTWvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:51:21 -0500
Date: Wed, 20 Feb 2008 23:51:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: sparse - make __CHECK_ENDIAN__ default enabled?
Message-ID: <20080220225132.GA22694@uranus.ravnborg.org>
References: <20080220220326.GA22328@uranus.ravnborg.org> <1203547186.25307.52.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203547186.25307.52.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:39:46PM -0800, Harvey Harrison wrote:
> On Wed, 2008-02-20 at 23:03 +0100, Sam Ravnborg wrote:
> > Hi Harvey.
> > 
> > Can I ask you to look into the worst offenders so we
> > can make -D__CHECK_ENDIAN__ enabled per default
> > in the kernel.
> > Or maybe we should do it anyway?
> 
> >From a quick test, the same places that spew sparse warnings, spew
> lots more sparse warnings, the places that are not so bad....are not
> so bad afterwards either.
> 
> There's still so many of the trivial warnings that maybe it's not the
> right time for this yet.  Ask me again when we get to the 2.6.26
> timeframe, we'll see how many I've gotten rid of by then.

OK - thanks for looking into it.

	Sam
