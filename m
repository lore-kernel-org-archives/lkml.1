Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYAIKbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYAIKbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIKbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:31:24 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:47552 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYAIKbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:31:23 -0500
Subject: Re: [GIT PATCH] Update to Chinese documents
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: torvalds@linux-foundation.org, gregkh@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org
In-Reply-To: <20080108131823.GB23947@uranus.ravnborg.org>
References: <1199796637.6835.7.camel@Gundam>
	 <20080108131823.GB23947@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Wed, 09 Jan 2008 18:41:06 +0800
Message-Id: <1199875266.21597.16.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2008 10:31:17.0357 (UTC) FILETIME=[C46EC1D0:01C852AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 21:18 +0800, Sam Ravnborg wrote:
> On Tue, Jan 08, 2008 at 08:50:37PM +0800, Li Yang wrote: 
> > Please pull from the doc branch at: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/leo/chinese.git doc 
> > 
> > to receive the following updates to in-tree Chinese documents 
> > and to add newly translated guideline documents.
> 
> Hi Li Yang.
> 
> In another thread we have discussed localized versions of Kconfig 
> files facilitating po files. 
> Will the community you represent here see any advantage in that and 
> would be interested to contribute?

AFAIK, a guy here had started to translate the Kconfig directly.
Changing to use po file should be a better approach.

> 
> What is generally seen as a showstopper is the amount of work needed 
> to do the translation - and keeping it up-to-date.

Sure.  The key is to have more participants to involve.  The work can't
be done without a large contributor base.

> 
> If lkml actually accept .po files in the kernel is not yet setteled 
> but no matter I would like kconfig to be extended to support it. 

More people will be interested to participate by accepting .po files in
the kernel.

- Leo

> For this work help is needed too. 
> It is a pick-up of the Linux Kernel Translation project 
> (http://tlktp.sourceforge.net/) where several kconfig patches exists.
> 
>         Sam
> 

