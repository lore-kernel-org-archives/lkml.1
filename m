Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZCEPsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZCEPsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZCEPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:48:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:48550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbZCEPsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:48:04 -0500
Subject: Re: [git-pull -tip] x86: msr architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305143726.GC7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain>
	 <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com>
	 <1236262346.2527.3.camel@ht.satnam>
	 <20090305143726.GC7347@alberich.amd.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 21:17:37 +0530
Message-Id: <1236268057.2527.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-03-05 at 15:37 +0100, Andreas Herrmann wrote:
> On Thu, Mar 05, 2009 at 07:42:26PM +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-03-05 at 14:54 +0100, Andreas Herrmann wrote:
> > 
> > > All nice suggestions but why in-kernel?
> > > 
> > 
> > In Kernel Space:
> > 
> > We can read/write MSRs and can change the bits and see it effect without
> > writing any code.
> 
> Sorry, I can't (or maybe I don't like to) follow.
> 
> (BTW, you don't even need to write C-code. You can use a one-liner in perl
> or python to seek and read any MSR using /dev/cpu/*/msr.)
> 

You are running these commands on shell when every thing is working.

What you will do if you are not getting the shell and kernel is dumping
or rebooting before that.

--
JSR

