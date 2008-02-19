Return-Path: <linux-kernel-owner+w=401wt.eu-S1763489AbYBSWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489AbYBSWQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762973AbYBSWO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:14:59 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:45726 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761673AbYBSWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N33hw93uYBM4ddiUERITZMp1h8acKAR0WQckqJEM6nYb3/nPnYqaNpKCOQ+DbrbtHsPYpNsWvrZIac/f0Ocu+4TLNE6rSrCpprBW/joPGX2Aajw3Td5XPZFM0iGa/4a7hOytffCtNgYxfb6tp7zxfY087Blu1tMm5BVMBx6Res4=
Subject: Re: Unable to continue testing of 2.6.25
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200802192255.02152.elendil@planet.nl>
References: <200802171025.30590.elendil@planet.nl>
	 <20080217131611.GA1403@cs181133002.pp.htv.fi>
	 <200802192255.02152.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 14:15:07 -0800
Message-Id: <1203459307.20298.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 22:55 +0100, Frans Pop wrote:
> On Sunday 17 February 2008, Adrian Bunk wrote:
> > The real problem is that the kernel seems to lack functionality you
> > require for doing some work.
> 
> Not sure how you reached that conclusion.
> 
> > Why does your work on the Debian Installer depend on VirtualBox and
> > can't be done with what the kernel already ships?
> 
> The fact that VirtualBox does not (yet) work for me with 2.6.25 means that 
> I'm unable to run 2.6.25 on my main desktop and do any real work. Rebooting 
> my desktop whenever I want to use VirtualBox is just not a realistic 
> option.
> That in turn means that I cannot do any more testing of 2.6.25, because most 
> of the testing I do consists of just using a new kernel and critically 
> observing the behavior of my system. As I've caught a fair number of bugs 
> that way for the past few releases, I'd say that's a useful contribution.

And it will be just as valuable when you stay with 2.6.24 finding bugs
there.

And once VirtualBox has been updated to work with 2.6.25, you can test
2.6.25.

Harvey

