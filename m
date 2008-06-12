Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYFLABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYFLABr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYFLABj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:01:39 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36986
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYFLABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:01:38 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: mainlining min-configs...
Date: Wed, 11 Jun 2008 19:01:33 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080611063921.GA27978@uranus.ravnborg.org> <48502304.1030304@am.sony.com>
In-Reply-To: <48502304.1030304@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111901.34630.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 14:09:56 Tim Bird wrote:
> Sam Ravnborg wrote:
> >>> When I get my kconfig patchset polished you will be able to do:
> >>>
> >>> make K=my_mini_config allnoconfig
> >>
> >> So you're renaming KCONFIG_ALLNOCONFIG then?
> >
> > Somehow yes. The K= notation I hope will see more use. Only very few
> > people know the KCONFIG_ALL*CONFIG= trick.
>
> Indeed.  I had never heard of it, but it appears to have been
> around for at least 18 months.  It looks like Randy Dunlap tried
> to submit some documentation for this in Oct 2006, but it didn't
> make it in?

Nor did the documentation I posted back in November 2005:
http://lwn.net/Articles/160497/

Nor its resubmission:
http://lwn.net/Articles/161086/

Nor its re-resubmission:
http://lkml.org/lkml/2006/7/6/404

Randy's submission was after those three...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
