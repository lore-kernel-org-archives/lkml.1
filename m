Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbYEGVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbYEGVxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYEGVxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:53:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbYEGVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:53:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Cloos <cloos@jhcloos.com>,
       "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: Regression: starting X locks box with git master
Date: Wed, 7 May 2008 23:53:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org> <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com> <m37iemq3qa.fsf@lugabout.jhcloos.org>
In-Reply-To: <m37iemq3qa.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072353.02085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of April 2008, James Cloos wrote:
> >>>>> "Yinghai" == Yinghai Lu <yhlu.kernel@gmail.com> writes:
> 
> Yinghai> Do you have CONFIG_X86_PAT in your .config?
> 
> I do not find that in .config at all, set or not:
> 
> :; grep X86_PAT /usr/src/linux-2.6/.config
> 
> returns nothing.
> 
> But the kernel which dies does generate this:
> 
> Apr 24 04:28:09 [kernel] [    0.000000] x86: PAT support disabled.

Has the problem been fixed in 2.6.26-rc1 or in the current -git?

Rafael
