Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYKMT7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYKMT7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYKMT67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:58:59 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58202 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYKMT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:58:58 -0500
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2008 14:58:58 EST
Subject: Re: [PATCH] depmod: sort output according to modules.order, take #2
From: Jon Masters <jonathan@jonmasters.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
In-Reply-To: <491C1158.8090901@gmail.com>
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com>
	 <477B71F0.8020706@gmail.com>  <200801031012.22776.rusty@rustcorp.com.au>
	 <1199318319.2044.22.camel@perihelion>  <491C1158.8090901@gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 13 Nov 2008 14:30:30 -0500
Message-Id: <1226604630.8114.45.camel@perihelion.int.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 20:36 +0900, Tejun Heo wrote:
> Jon Masters wrote:
> > On Thu, 2008-01-03 at 10:12 +1100, Rusty Russell wrote:
> > 
> >> Oh, sorry.  Jon is now module-init-tools maintainer, and I've cc'd him and 
> >> forwarded your original patch.
> > 
> > Ta. I was semi-offline last week due to holidays, but already saw the
> > original mail and have another fix for debug sections - will sort it.
> 
> Jon, this patch hasn't made into module-init-tools after 10 months.  Ping?

Oops. I missed that one. Also reminds me I should post a patch to clean
up some of these Modules files on a kernel make clean, I think the
markers file was still kicking around last time I built out of tree
modules...should check that.

Jon.


