Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYFKTsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYFKTsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYFKTr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:47:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35048 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYFKTr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:47:58 -0400
Date: Wed, 11 Jun 2008 21:48:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Rob Landley <rob@landley.net>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
Message-ID: <20080611194840.GA12794@uranus.ravnborg.org>
References: <48447615.5050806@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org> <200806110009.22542.rob@landley.net> <20080611063921.GA27978@uranus.ravnborg.org> <48502304.1030304@am.sony.com> <20080611193639.GB2958@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611193639.GB2958@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 10:36:39PM +0300, Adrian Bunk wrote:
> On Wed, Jun 11, 2008 at 12:09:56PM -0700, Tim Bird wrote:
> > Sam Ravnborg wrote:
> > >>> When I get my kconfig patchset polished you will be able to do:
> > >>>
> > >>> make K=my_mini_config allnoconfig
> > >> So you're renaming KCONFIG_ALLNOCONFIG then?
> > > 
> > > Somehow yes. The K= notation I hope will see more use. Only very few
> > > people know the KCONFIG_ALL*CONFIG= trick.
> > 
> > Indeed.  I had never heard of it, but it appears to have been
> > around for at least 18 months.  It looks like Randy Dunlap tried
> > to submit some documentation for this in Oct 2006, but it didn't
> > make it in?
> >...
> 
> Randy's patch that documents KCONFIG_ALLCONFIG is in Linus' tree since
> April 2006.
The one I refer to is not.

	Sam
