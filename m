Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYFJDOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYFJDOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYFJDOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:14:41 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:40188
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759206AbYFJDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:14:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcBAH91TUh8qNvt/2dsb2JhbAAIsCs
X-IronPort-AV: E=Sophos;i="4.27,615,1204470000"; 
   d="scan'208";a="327639973"
Subject: Re: mainlining min-configs...
From: Ben Nizette <bn@niasdigital.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Rob Landley <rob@landley.net>, Adrian Bunk <adrian.bunk@movial.fi>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <484DDAD9.2000306@am.sony.com>
References: <48447615.5050806@am.sony.com>
	 <20080604194002.GF4189@cs181133002.pp.htv.fi>
	 <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net>
	 <484DDAD9.2000306@am.sony.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 10 Jun 2008 13:14:36 +1000
Message-Id: <1213067676.3213.27.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-09 at 18:37 -0700, Tim Bird wrote:
> Rob Landley wrote:
> > On Friday 06 June 2008 18:47:47 Tim Bird wrote:
> >> At a minimum, it would be nice to have a few nice examples
> >> of really, really small configs for things like qemus for different
> >> architectures (just to give embedded developers who are working
> >> on size a starting point).
> > 
> > That's more or less what I'm trying to do with my Firmware Linux project: 
> > creating cross compilers and minimal native build environments for every qemu 
> > target.
> 
> Any chance of getting your minimal configs from Firmware Linux mainlined?

allnoconfig? ;-)

> 
> Does anyone else think this would be valuable?  If not in mainline, it
> would be nice to collect them somewhere, to compare what options different
> developers decide turn on or off.

Seriously though I maintain a bunch of AVR32 minimal configs.  I keep
them as a smallest-working-config baseline to build on; I'm sure others
would get value from having easy access to that kind of thing.

IMO It'd be nice to wire them to an automagic bloat-o-meter as well, but
I suspect no-one would really take notice anyway.

	--Ben.
