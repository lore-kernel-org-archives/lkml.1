Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYHFKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYHFKQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYHFKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:10:34 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:51382 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbYHFKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:10:29 -0400
In-Reply-To: <20080805225524.GB4006@fieldses.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for	on
 access	scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 11:09:34 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 11:10:23,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 11:10:23,
	Serialize complete at 06/08/2008 11:10:23,
	S/MIME Sign failed at 06/08/2008 11:10:23: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 11:09:36,
	Serialize complete at 06/08/2008 11:09:36
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806101028.B87BA2FE88B@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote on 05/08/2008 23:55:24:

> On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
> > Please contact me privately or (preferably the list) for questions,
> > comments, discussions, flames, names, or anything.  I'll do complete
> > rewrites of the patches if someone tells me how they don't meet their
> > needs or how they can be done better.  I'm here to try to bridge the
> > needs (and wants) of the anti-malware vendors with the technical
> > realities of the kernel.  So everyone feel free to throw in your two
> > cents and I'll try to reconcile it all.  These 5 patches are part 1.
> > They give us a working able solution.
> > 
> > >From my point of view patches forthcoming and mentioned below should
> > help with performance for those who actually have userspace scanners 
but
> > also could presents be implemented using this framework.
> > 
> > 
> > Background
> > ++++++++++
> > There is a consensus in the security industry that protecting against
> > malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
> > of so-called on-access scanning is usable and reasonable approach.
> 
> Can you point to any helpful explanations of that concensus?

I can't, but everyone is doing it so that is at least an implied 
consensus.
 
> Off-hand it's surprising.  (A defense that depends on cataloging every
> possible individual attack sounds difficult!)

Maybe it is not how you imagine it? It is not a database of every possible 
individual attack but there are more intelligent methods. But I am not an 
expert in this field to explain it better..

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

