Return-Path: <linux-kernel-owner+w=401wt.eu-S965049AbXCGLGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049AbXCGLGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXCGLGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:06:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:44615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965049AbXCGLGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:06:35 -0500
Subject: Re: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Collins <paul@briny.ondioline.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       francesco foresti <frafore@tiscali.it>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <873b4h64dm.fsf@briny.internal.ondioline.org>
References: <200703051414.15802.frafore@tiscali.it>
	 <1173143894.3461.240.camel@pmac.infradead.org>
	 <87tzwzqgrx.fsf@briny.internal.ondioline.org>
	 <1173177329.3461.291.camel@pmac.infradead.org>
	 <873b4h64dm.fsf@briny.internal.ondioline.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 12:04:39 +0100
Message-Id: <1173265479.9349.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 17:53 +1300, Paul Collins wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> 
> > On Tue, 2007-03-06 at 14:53 +1300, Paul Collins wrote:
> >> In case it's of interest, 2.6.20 has been running fine on my
> >> PowerBook5,4. 
> >
> > How much memory? What if you boot with mem=512M or mem=256M?
> 
> 1GB.  Also works fine when booted with those options.

Can you try 2.6.21-rc3 ? We just fixed a nasty bug causing memory
corruption.

Ben.


