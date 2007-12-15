Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbXLOGqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbXLOGqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXLOGqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:46:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXLOGqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:46:15 -0500
Date: Sat, 15 Dec 2007 01:45:55 -0500
From: Dave Jones <davej@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215064555.GA7211@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215055218.GM19691@waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:52:18PM -0600, Matt Mackall wrote:
 
 > Then I kindly submit that you should instead withdraw the code that
 > allows you to use WARN_ON in a condition in the first place.
 > 
 > Note that Dave Jones is currently poking at making WARN_ON
 > out-of-line, so you're liable to collide with him.
 
Actually I'm not likely to get back to this until post xmas.
I'm on vacation until then from today, so I'll be paying less
attention to stuff than usual.

	Dave

-- 
http://www.codemonkey.org.uk
