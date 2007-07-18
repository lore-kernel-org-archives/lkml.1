Return-Path: <linux-kernel-owner+w=401wt.eu-S935531AbXGRReo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531AbXGRReo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932983AbXGRReb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:34:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45832 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763682AbXGRRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:34:30 -0400
Date: Wed, 18 Jul 2007 10:34:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
Message-Id: <20070718103456.cf32bf78.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
	<Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
	<20070718094119.4a26ae03.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 19:17:49 +0200 (CEST) Jan Engelhardt wrote:

> 
> On Jul 18 2007 09:41, Randy Dunlap wrote:
> >
> >Looks good to me except that help text should be indented by
> >2 more spaces according to CodingStyle.
> 
> Who invented that rule anyway... the "---help---" marker (note the dashes)
> clearly separates things already.
> Here you go.

I have no idea where it came from.  (not me)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
