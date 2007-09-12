Return-Path: <linux-kernel-owner+w=401wt.eu-S969359AbXILRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969359AbXILRuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbXILRtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:49:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44584 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348AbXILRtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:49:52 -0400
Date: Wed, 12 Sep 2007 19:51:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Message-ID: <20070912175116.GB18311@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <20070912170529.GA18311@uranus.ravnborg.org> <1189617081.31502.78.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189617081.31502.78.camel@tara.firmix.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 07:11:21PM +0200, Bernd Petrovitsch wrote:
> On Wed, 2007-09-12 at 19:05 +0200, Sam Ravnborg wrote:
> [....]
> > Being rpm ignorant I do not know what the expected content of a kernel-source RPM
> > are but this is the available targets for kernel packaging (from make help):
> 
> The kernel-source including all patches and configured as usually to be
> found under
> /usr/src/linux-$VERSION (or so). One needs that for e.g. external
> modules.
For external modules you need a fully build kernel which may be 
clean up by "make clean".
Thats not the same as a source RPM as per my understanding.

	Sam
