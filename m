Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYICUkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYICUkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYICUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:39:55 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43688 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbYICUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:39:54 -0400
Date: Wed, 3 Sep 2008 16:39:54 -0400
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-kernel@vger.kernel.org, Corentin CHARY <corentincj@iksaif.net>
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Message-ID: <20080903203954.GT12474@csclub.uwaterloo.ca>
References: <20080903170649.GF12476@csclub.uwaterloo.ca> <200809031859.28203.alistair@devzero.co.uk> <20080903201620.GS12474@csclub.uwaterloo.ca> <200809032132.34967.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809032132.34967.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:32:34PM +0100, Alistair John Strachan wrote:
> On Wednesday 03 September 2008 21:16:20 Lennart Sorensen wrote:
> > On Wed, Sep 03, 2008 at 06:59:28PM +0100, Alistair John Strachan wrote:
> > > Unless I'm mistaken, the current asus-laptop maintainer is Corentin
> > > Chary, who I've added to CC on your behalf.
> >
> > Excellent.  Now where do I find such info?
> 
> MAINTAINERS, though admittedly the section is dubiously named. His name's also 
> present in the copyright in the source file (drivers/misc/asus-laptop.c). It's 
> also present in the source code log for this file (git log drivers/misc/asus-
> laptop.c) if you discount people who have made only janitorial or API changes.
> 
> Either way, he's CC'ed, and hopefully more responsive than the sourceforge 
> project :-) If not, pester Andrew Morton with the patch (and Andi Kleen, since 
> it's ACPI territory).

OK.  I will go test the patch out and see if it still works.

-- 
Len Sorensen
