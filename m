Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZFJQK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZFJQK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZFJQKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:10:50 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:38364 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFJQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:10:50 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2FDB06.8020707@lwfinger.net>
Date: Wed, 10 Jun 2009 11:10:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>	 <4A2BCC6F.8090004@redhat.com>	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>	 <20090608101739.GA15377@csn.ul.ie>	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>	 <20090608110303.GD15377@csn.ul.ie>	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>	 <1244534315.5024.34.camel@penberg-laptop>	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>	 <1244648659.23799.26.camel@penberg-laptop> <1244648968.23799.27.camel@penberg-laptop>
In-Reply-To: <1244648968.23799.27.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> Argh, that patch has a typo. Please try this one instead.
> 
> 			Pekka

I installed this patch on top of the other one and have started
testing. It usually takes almost a day for it to occur.

Larry
