Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZCERCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZCERCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZCERB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:01:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38905 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZCERB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:01:57 -0500
Date: Thu, 5 Mar 2009 10:01:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Message-ID: <20090305170154.GA1021@parisc-linux.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <49AA4389.8010605@kernel.org> <200903010929.17904.prakash@punnoor.de> <200903040815.38387.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903040815.38387.prakash@punnoor.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 08:15:37AM +0100, Prakash Punnoor wrote:
> Hmmm,
> 
> 2.6.29-rc7 is released, but the last two patches here in the thread have not 
> been picked up. Why?

I'm watching the PCI tree while Jesse is away and I didn't realise these
patches were urgent to include.  I'll put them in a git tree and send
Linus a pull request.  I just saw him wandering around with his
suitcase, so I think he'll be back home and processing pull requests
this evening.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
