Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZCESko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZCESko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZCESkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:40:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:56457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbZCESkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:40:35 -0500
Subject: Re: [git-pull -tip] x86: msr architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305182318.GE7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain>
	 <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com>
	 <1236262346.2527.3.camel@ht.satnam>
	 <20090305143726.GC7347@alberich.amd.com>
	 <1236268057.2527.23.camel@ht.satnam>
	 <20090305182318.GE7347@alberich.amd.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 00:10:12 +0530
Message-Id: <1236278412.3316.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 19:23 +0100, Andreas Herrmann wrote:
> On Thu, Mar 05, 2009 at 09:17:37PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > You are running these commands on shell when every thing is working.
> > 
> > What you will do if you are not getting the shell and kernel is dumping
> > or rebooting before that.
> 
> In this case a deep debugfs tree with all the MSR details is not of
> use either.
> 

Yes, then functions from msr_debug.c will dump the details on screen if
seq is NULL (thats why I am also using printk ;-)

Cheers,
--
JSR

