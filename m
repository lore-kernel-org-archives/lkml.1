Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZKYDDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZKYDDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbZKYDDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:03:40 -0500
Received: from ozlabs.org ([203.10.76.45]:34821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbZKYDDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:03:40 -0500
From: Michael Neuling <mikey@neuling.org>
To: Nathan Fontenot <nfont@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Kernel DLPAR infrastructure
In-reply-to: <31581.1259115310@neuling.org>
References: <4B0C8B45.6080804@austin.ibm.com> <4B0C8CE3.4010207@austin.ibm.com> <31581.1259115310@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Wed, 25 Nov 2009 13:15:10 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 25 Nov 2009 14:03:45 +1100
Message-ID: <6799.1259118225@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <31581.1259115310@neuling.org> you wrote:
> 
> 
> In message <4B0C8CE3.4010207@austin.ibm.com> you wrote:
> > This patch provides the kernel DLPAR infrastructure in a new filed named
> > dlpar.c.  The functionality provided is for acquiring and releasing a resou
rc
> e
> > from firmware and the parsing of information returned from the
> > ibm,configure-connector rtas call.  Additionally this exports the pSeries
> > reconfiguration notifier chain so that it can be invoked when device tree 
> > updates are made.
> > 
> > Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com> 
> 
> These look like they got white space munged somewhere...

Gah, sorry, they are fine

Mikey
