Return-Path: <linux-kernel-owner+w=401wt.eu-S1030370AbXDRX7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370AbXDRX7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030419AbXDRX7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:59:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030370AbXDRX7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:59:30 -0400
Date: Wed, 18 Apr 2007 19:58:06 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, davej@codemonkey.org.uk,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Message-ID: <20070418235806.GD20204@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>, davej@codemonkey.org.uk,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704181524.16980.lenb@kernel.org> <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain> <200704181723.16241.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704181723.16241.lenb@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 05:23:15PM -0400, Len Brown wrote:

 > > p.p.s.  patch improvements that will let me avoid doing any of that
 > > myself always welcome. :-)
 > 
 > well, I'm sorry that I've known about the APM issue for a long time
 > and done nothing about it.  I did ping davej when he broke it,
 > but his to-do list is probably even longer than mine.

ping timeout.

I don't recall too many of the details surrounding those changes,
but I certainly won't stand in the way of anyone trying to fix it.
It sounds like you and Robert are on top of it, or do you want
me to poke at it ?

	Dave

-- 
http://www.codemonkey.org.uk
