Return-Path: <linux-kernel-owner+w=401wt.eu-S934749AbXK3OfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbXK3OfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXK3Oeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:34:46 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34874 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbXK3Oeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:34:46 -0500
Date: Fri, 30 Nov 2007 09:34:45 -0500
To: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071130143445.GA2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474EAD18.6040408@stellatravel.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:14:16PM +0000, Ben Crowhurst wrote:
> Has Objective-C ever been considered for kernel development?

Doesn't objective C essentially require a runtime to provide a lot of
the features of the language?  If it does (as I suspect) then it is
totally unsiatable for kernel development.

That and object oriented languages in general are badly designed and a
bad idea.  Having not used objective C I have no idea if it qualifies as
badly designed or not.  Certainly C++ and java are both very badly
designed.

Besides the kernel does a wonderful job doing object oriented design
where apropriate using C without any of the stupidities added by the
common OO languages.

--
Len Sorensen
