Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLIRJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLIRJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLIRJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:09:07 -0500
Received: from waste.org ([66.93.16.53]:48414 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXLIRJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:09:05 -0500
Date: Sun, 9 Dec 2007 11:08:52 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] random: step more rapidly through the pool when adding and extracting
Message-ID: <20071209170852.GZ19691@waste.org>
References: <2.753618428@selenic.com> <6.753618428@selenic.com> <20071209014820.GV17037@thunk.org> <20071208200055.00762c19.akpm@linux-foundation.org> <20071209042204.GR19691@waste.org> <20071209125541.GA17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209125541.GA17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 07:55:41AM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 10:22:04PM -0600, Matt Mackall wrote:
> > 
> > It did. My laptop didn't relay them through my smarthost and my domain
> > has an SPF record.
> 
> Ah, yes:
> 
> http://homepages.tesco.net/~J.deBoynePollard/FGA/smtp-spf-is-harmful.html

Yep, I temporarily set it up to mitigate a spate of From: forgeries
against my domain, then it bit me later.

-- 
Mathematics is the supreme nostalgia of our time.
