Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFXGp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFXGp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZFXGpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:45:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:59516 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZFXGpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:45:17 -0400
Subject: Re: [merged]
 proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from
 -mm tree
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090623233247.7ed661b7.akpm@linux-foundation.org>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	 <1245824444.22613.3.camel@wall-e>
	 <20090623233247.7ed661b7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 08:45:03 +0200
Message-Id: <1245825903.23818.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 23.06.2009, 23:32 -0700 schrieb Andrew Morton:
> On Wed, 24 Jun 2009 08:20:44 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > what is with the associated
> > procfs-provide-stack-information-for-threads-v08.patch
> > patch?
> > 
> > There was no real objections against this patch, so why not merge it for
> > 2.6.31?
> 
> Alexey pointed out that it doesn't actually work.

That is not true... it works. With my patch the kernel does exactly know
where the thread stack is and therefor it is easy to determinate the
associated map.


