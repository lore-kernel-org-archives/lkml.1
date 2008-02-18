Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYBRLk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYBRLk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYBRLkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:40:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42501 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbYBRLkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:40:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Mon, 18 Feb 2008 12:38:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lenb@kernel.org, yakui.zhao@intel.com, csnook@redhat.com
References: <200802172304.00322.rjw@sisk.pl> <20080218101734.GA6348@linux.vnet.ibm.com>
In-Reply-To: <20080218101734.GA6348@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181238.26287.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Dhaval Giani wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9982
> > Subject		: 2.6.25-rc1 panics on boot
> > Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Date		: 2008-02-13 18:03
> > References	: http://lkml.org/lkml/2008/2/13/363
> > Handled-By	: Chris Snook <csnook@redhat.com>
> 
> Hi Rafael,
> 
> A fix was proposed and accepted at
> http://bugzilla.kernel.org/attachment.cgi?id=14832&action=view .
> 
> The bug has been marked as resolved. (You might want to modify your
> script to handle such cases.)

The rule is that the regressions are listed as long as they are not fixed _in_
_the_ _mainline_ (or not rejected, in some rare cases), in which cases the
Bugzilla entries should be explicitly marked as "closed".

Thanks,
Rafael
