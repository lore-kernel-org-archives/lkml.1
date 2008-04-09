Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYDIUID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYDIUID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYDIUHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:07:54 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2331 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYDIUHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:07:54 -0400
Date: Wed, 9 Apr 2008 21:07:55 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409200746.GR17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org> <20080409084606.GD19010@one.firstfloor.org> <20080409131420.GL17915@shadowen.org> <alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr> <20080409135840.GO17915@shadowen.org> <20080409095326.8e306c41.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409095326.8e306c41.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 09:53:26AM -0700, Andrew Morton wrote:
> On Wed, 9 Apr 2008 14:58:40 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > The originally suggested layout was:
> > 
> > 			printk(
> > "Oh ....",
> > 				a, b);
> 
> Dunno about others, but when I see that idiom I fall over stunned and 
> can't get up again.

That remains me of nethack.  I'll start with the width breaker.

-apw
