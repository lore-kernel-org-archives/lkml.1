Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZGAJAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZGAJAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZGAJA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:00:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbZGAJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:00:27 -0400
Date: Tue, 30 Jun 2009 08:31:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Arnold <jbarnold@ksplice.com>
Cc: linux-kernel@vger.kernel.org, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com, nelhage@ksplice.com, price@ksplice.com,
       geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
Message-ID: <20090630063152.GC1351@ucw.cz>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-25 05:51:56, Jeff Arnold wrote:
> Hello,
> 
> The Ksplice team [1] is now providing rebootless kernel updates for Ubuntu 
> 9.04 Jaunty to anyone who configures their machine to receive them [2].  
> In short, users can click a few buttons and start getting all of the 
> Ubuntu kernel security updates applied to their system without rebooting.  
> No initial kernel changes are needed.

Nice advertisment...

> Ksplice applies traditional source code patches to unmodified Linux 
> kernels.  It can be used to apply all of the Linux security patches over 
> multiple years [7], and it can also apply reliability patches and other 
> bug fixes, such as from the Linux stable tree.

Hmmm, so what are its limits? How much manual work is involved? Lets
say I want 2.6.30 -> 2.6.31-rc1... that's just source patch, right?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
