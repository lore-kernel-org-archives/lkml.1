Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYFRU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYFRU5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYFRU5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:57:04 -0400
Received: from lazybastard.de ([212.112.238.170]:38055 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYFRU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:57:04 -0400
Date: Wed, 18 Jun 2008 22:56:07 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080618205607.GI10271@logfs.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr> <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr> <20080617135722.374673b9@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171634040.32473@fbirervta.pbzchgretzou.qr> <20080618131514.7ea8af7e@mercedes-benz.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080618131514.7ea8af7e@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 June 2008 13:15:14 +0200, Maxim Shchetynin wrote:
> 
> Our users want to have a file system with bigger block sizes (64KB, 16MB, ...).

Good reason.

> They also don't want to keep metadata on DDR2 media, but to be able to use a complete DDR2 for their applications data.

This I find surprising.  Isn't DDR2 actually the slower type of memory?
So you spend fast memory to store metadata in order to save slow memory?

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
