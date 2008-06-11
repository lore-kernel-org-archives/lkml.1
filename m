Return-Path: <linux-kernel-owner+w=401wt.eu-S1750794AbYFKTWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750794AbYFKTWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbYFKTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:21:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55811 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbYFKTVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:21:52 -0400
Date: Wed, 11 Jun 2008 21:22:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Rob Landley <rob@landley.net>, Adrian Bunk <bunk@kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
Message-ID: <20080611192234.GB12525@uranus.ravnborg.org>
References: <48447615.5050806@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org> <200806110009.22542.rob@landley.net> <20080611063921.GA27978@uranus.ravnborg.org> <48502304.1030304@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48502304.1030304@am.sony.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:09:56PM -0700, Tim Bird wrote:
> Sam Ravnborg wrote:
> >>> When I get my kconfig patchset polished you will be able to do:
> >>>
> >>> make K=my_mini_config allnoconfig
> >> So you're renaming KCONFIG_ALLNOCONFIG then?
> > 
> > Somehow yes. The K= notation I hope will see more use. Only very few
> > people know the KCONFIG_ALL*CONFIG= trick.
> 
> Indeed.  I had never heard of it, but it appears to have been
> around for at least 18 months.  It looks like Randy Dunlap tried
> to submit some documentation for this in Oct 2006, but it didn't
> make it in?
> 
> Is this feature widely used?  Should it be doc'ed now
> or are you about to make it obsolete?
I will most likely obsolete all except KCONFIG_ALLCONFIG
And I'm afraid I have Randy patch somewhere.

	Sam
