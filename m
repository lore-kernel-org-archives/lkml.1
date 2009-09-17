Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZIQDSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZIQDSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbZIQDSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbZIQDSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:18:03 -0400
Date: Wed, 16 Sep 2009 23:17:59 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kurt Roeckx <kurt@roeckx.be>
Subject: Re: linux-next: cpufreq-current tree build warning
Message-ID: <20090917031759.GB30706@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kurt Roeckx <kurt@roeckx.be>
References: <20090917120651.f0cdf4c2.sfr@canb.auug.org.au> <20090917022726.GA30706@redhat.com> <20090917125556.1125d8ae.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917125556.1125d8ae.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 12:55:56PM +1000, Stephen Rothwell wrote:
 > so, no.
 > (origin/master is Linus' tree of about 2 hours ago, commit
 > ab86e5765d41a5eb4239a1c04d613db87bea5ed8 "Merge
 > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6")
 > 
 > Looking further, this is the cpureq-current tree I am complaining about,
 > in the cpufreq tree, you also have:

Oh, from the 'fixes' branch ?  Just drop that for now, and only pick up 'next'
(though next pull request went to linus today, so the whole thing should be
 gone soon).

	Dave
