Return-Path: <linux-kernel-owner+w=401wt.eu-S933037AbYB2SrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbYB2SrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbYB2SrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:47:02 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbYB2SrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:47:00 -0500
Date: Fri, 29 Feb 2008 18:46:49 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Message-ID: <20080229184649.GJ1788@agk.fab.redhat.com>
Mail-Followup-To: Ritesh Raj Sarraf <rrs@researchut.com>,
	device-mapper development <dm-devel@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christophe Saout <christophe@saout.de>,
	linux-kernel@vger.kernel.org
References: <200802281924.03996.rrs@researchut.com> <20080228232048.51e28c1d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228232048.51e28c1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:20:48PM -0800, Andrew Morton wrote:
> On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:
> > Kernel: 2.6.24
> > Distribution: Debian Testing/Unstable
> > Tainted: Yes (nvidia proprietary drivers)

Any chance you can try to reproduce it upstream e.g. in 2.6.25-rc3?

There have been significant changes in this area of the code.

Alasdair
-- 
agk@redhat.com
