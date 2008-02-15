Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYBOXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYBOXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYBOXJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:09:20 -0500
Received: from testure.choralone.org ([194.9.77.134]:45885 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYBOXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:09:19 -0500
Date: Fri, 15 Feb 2008 18:09:10 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Petr =?utf-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e_powersaver.c
Message-ID: <20080215230910.GC9132@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Petr =?utf-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>,
	linux-kernel@vger.kernel.org
References: <47B5E61F.3030603@century.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B5E61F.3030603@century.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 08:21:03PM +0100, Petr Titěra wrote:
 > Hello,
 > 
 >     is there some reason for printing current voltage and multiplier of 
 > processor after each change? This change was added by commit 553ae38c. 
 > If this required for some reason can be this output changed to use 
 > KERN_DEBUG level?

I think that's just leftover debugging cruft, I'll remove it.

Thanks,

	Dave 

-- 
http://www.codemonkey.org.uk
