Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYAJTSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYAJTSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYAJTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:18:43 -0500
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:32898 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYAJTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:18:42 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: kinit (was: sleep before boot panic)
Date: Thu, 10 Jan 2008 20:20:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Bernd Schubert <bernd-schubert@gmx.de>, linux-kernel@vger.kernel.org
References: <200801061908.43010.bernd-schubert@gmx.de> <20080108160645.GA4574@ucw.cz> <47850C89.2040805@zytor.com>
In-Reply-To: <47850C89.2040805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801102020.07786.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008, H. Peter Anvin wrote:
> Pavel Machek wrote:
> > 
> >> Of course, if we'd been using kinit, "soft panic" would 
> >> have been done exclusively in userspace...
> > 
> > What's the status of kinit, btw?
> > 							Pavel
> 
> It's bitrotted a bit since it was first rejected.  It wouldn't take too 
> much work to bring it back up to speed, however.  klibc, and some of the 
> kinit components, are used for the initramfs in Debian.

Yes, and I like most of it. The only thing really missing for me 
is LVM support. Debian (?) did a evil hack to make it work.
Maybe one day this itches soo much, I'll even scratch it :-)

Then I'll be able to test kernels on a standard LVM installation again.

So please keep up the good work!


Best Regards

Ingo Oeser
