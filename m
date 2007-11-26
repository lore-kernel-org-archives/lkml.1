Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXKZXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXKZXDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXKZXD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:03:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35358 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXKZXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:03:28 -0500
Message-ID: <474B50BC.5030108@davidnewall.com>
Date: Tue, 27 Nov 2007 09:33:24 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Josh Goldsmith <joshin@hotmail.com>
CC: pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
References: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl> <474AB4A3.8050802@davidnewall.com> <BLU103-DAV9F8A12C3BFA4AAAC0B7B4D6750@phx.gbl>
In-Reply-To: <BLU103-DAV9F8A12C3BFA4AAAC0B7B4D6750@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Goldsmith wrote:
> David:  The exact command this time was a "tar jxf 
> linux-2.6.23.tar.bz2" as part of an emerge (gentoo).  Gnu tar version 
> 1.18 but has happened with prior versions too.  I replicated it after 
> my post by manually untarring it on the command line and can almost 
> always replicate the problem with any large (GCC/kernel) tarball.  If 
> I shut down all other processes, the untar will go longer but 
> eventually the oom-killer will be invoked.

Into which directory were you extracting the files?
