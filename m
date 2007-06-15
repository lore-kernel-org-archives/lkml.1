Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbXFOOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbXFOOnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXFOOnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:43:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33216 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXFOOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:43:05 -0400
Date: Fri, 15 Jun 2007 15:43:01 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Paulo Marques <pmarques@grupopie.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615144301.GV21478@ftp.linux.org.uk>
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com> <200706151403.57178.bernd.paysan@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706151403.57178.bernd.paysan@gmx.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 02:03:55PM +0200, Bernd Paysan wrote:
> > I've contributed some code for the kernel (unlike yourself, AFAICT), and
> > believe me, I did so under GPL v2. The COPYING file is pretty much self
> > explanatory, so I didn't need to add any explicit license statement to
> > my code.
> 
> It's not, it's a personal comment from a misunderstanding of the GPL text. 
> It's as valid as the "closed source kernel modules are legal" comment that 
> was there some years ago.

You forgot something.  Namely, that file *without* any mentioning of
GPL or other license is either illegal to distribute at all, under
any license, *OR* inherits the default license of the project.  Which
is to say, what is stated in COPYING.

Take your pick.  For what it's worth, it would be interesting to hear
the opinion of RMS - both on how much of the kernel is possible to
distribute under v3 according to him and on the morality of your position.
