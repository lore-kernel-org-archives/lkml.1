Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZIWVoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZIWVoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZIWVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:44:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZIWVoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:44:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Date: Wed, 23 Sep 2009 23:45:12 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909230151.36678.rjw@sisk.pl> <20090923142225.GA2603@bizet.domek.prywatny>
In-Reply-To: <20090923142225.GA2603@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909232345.12186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 September 2009, Karol Lewandowski wrote:
> On Wed, Sep 23, 2009 at 01:51:36AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday 23 September 2009, Karol Lewandowski wrote:
> > > On Fri, Sep 18, 2009 at 12:27:37AM +0200, Rafael J. Wysocki wrote:
> > > > Adding linux-mm to the CC list.
> > > 
> > > I've hit this bug 2 times since my last email.  Is there anything I
> > > could do?
> > > 
> > > Maybe I should revert following commits (chosen somewhat randomly)?
> > > 
> > > 1. 49255c619fbd482d704289b5eb2795f8e3b7ff2e
> > > 
> > > 2. dd5d241ea955006122d76af88af87de73fec25b4 - alters changes made by
> > > commit above
> > > 
> > > Any ideas?
> > 
> > You can try that IMO.
> 
> Reverting commits above made situation worse.  Hints?  Obvious
> solutions? ;-)

Not really, at least not from me. :-(

Best,
Rafael
