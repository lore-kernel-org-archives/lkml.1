Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0BGXYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:24:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0BGXYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:24:46 -0500
Date: Sun, 7 Feb 2010 18:24:41 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davej@redhat.com, cebbert@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       dwmw2@infradead.org, airlied@redhat.com, perex@perex.cz,
       eparis@redhat.com
Subject: Re: kerneloops.org oops/warning report for the week ending
	February 7, 2010
Message-ID: <20100207232441.GT24051@bombadil.infradead.org>
References: <20100207103828.7e7b1e29@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100207103828.7e7b1e29@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 10:38:28AM -0800, Arjan van de Ven wrote:
> Rank 1: dquot_claim_space (warning)
> 	Reported 440404 times (482753 total reports)
> 	Interaction between EXT4 and the quota code.
> 	It seems to have gotten really worse in the latest Fedora 12 kernel; botched backport?
> 	This warning was last seen in version 2.6.33-rc4, and first seen in 2.6.30.
> 	More info: http://www.kerneloops.org/searchweek.php?search=dquot_claim_space
> 

We don't have any patches against jbd{,2} or ext4 in that kernel...

regards, Kyle
