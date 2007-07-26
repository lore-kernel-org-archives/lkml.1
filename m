Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbXGZPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbXGZPr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbXGZPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:47:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXGZPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:47:21 -0400
Date: Thu, 26 Jul 2007 17:47:18 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726154718.GA25561@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de> <20070726154415.GB15969@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070726154415.GB15969@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:44]:
> > 
> > Of course, but that's why the patch doesn't change this by default but
> > gives the user the choice.
> > 
> 
> What value will distro set it to by default?

0.

> Can we be more specific in terms of functionality and code that exactly
> what we are trying to do after panic?

Well, KDB, but now everybody answers with “not mainline -- doesn't
count”.


Thanks,
   Bernhard
