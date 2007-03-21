Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXCUXpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXCUXpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXCUXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:45:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbXCUXp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:45:29 -0400
Date: Wed, 21 Mar 2007 19:43:18 -0400
From: Dave Jones <davej@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070321234318.GE9092@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Willy Tarreau <w@1wt.eu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6> <p73y7lu5yt6.fsf@bingen.suse.de> <20070320165736.GA19781@redhat.com> <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org> <20070321232433.GX943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321232433.GX943@1wt.eu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 12:24:33AM +0100, Willy Tarreau wrote:
 
 > Then a printk() on every open() should be enough. We've all been seeing
 > "Warning: tcpdump uses obsolete AF_PACKET"... and it finally disappeared.

There's a difference.  We have the source for tcpdump.

	Dave

-- 
http://www.codemonkey.org.uk
