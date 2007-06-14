Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbXFNQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbXFNQld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXFNQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:41:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52024 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXFNQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:41:26 -0400
Date: Thu, 14 Jun 2007 17:41:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614164124.GP21478@ftp.linux.org.uk>
References: <466A3EC6.6030706@netone.net.tr> <200706141023.21624.bernd.paysan@gmx.de> <20070614153935.GO21478@ftp.linux.org.uk> <200706141832.58526.bernd.paysan@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706141832.58526.bernd.paysan@gmx.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 06:32:57PM +0200, Bernd Paysan wrote:

> BTW: If I grep through Linux, I find two files where you have noted your 
> copyright and the release conditions (GPL v2), and I think last time I did 
> the same thing, I found two GPLv2-files, as well - all other files with "Al 
> Viro" in it apparently have multiple authors. These two files may be the 
> same ones, or maybe there are two other files, making it four in total (or 
> some further I missed, the text of v2 only is not as normed as the text 
> for "v2 or later", but in general it's rare). These files clearly have to 
> be rewritten or premission has to be asked when updating COPYING to GPLv3. 
> But that's not a show-stopper.
 
Rot.  "Multiple authors" doesn't get you out of that.  If you take a code
available under GPLv2 or later and combine it with code under specific
version of GPL, result is under than specific version of GPL.  If you want
to argue against that, make sure to Cc RMS on that, I would really like to
hear his opinion.

Multiple authors == need permission from each author with enough
contributions to that file to make the contributions in question
copyrightable.

And in my case (and case of gregkh, and...) that would be considerably
more than a couple of files.  Really.
