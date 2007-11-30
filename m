Return-Path: <linux-kernel-owner+w=401wt.eu-S934982AbXK3Oh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbXK3Oh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbXK3OhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:37:15 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41436 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbXK3OhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:37:14 -0500
Date: Fri, 30 Nov 2007 09:37:13 -0500
To: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>
Cc: loic.grenie@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071130143713.GB2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com> <474FF0FE.50208@stellatravel.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474FF0FE.50208@stellatravel.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 11:16:14AM +0000, Ben Crowhurst wrote:
> But are embedded systems not rapidly moving on. Turning to stare at the 
> ADSL X6 modem with MB's of ram.

Some embedded systems run on batteries, so the less ram they have to
power the better, and the less cpu cycles that have to spend executing
code the less power they consume.  An ADSL modem on your desk doesn't
have any of those worries, it just has to work and if doubling the ram
cuts the development problems by a lot, then that might have been a
worthwhile trade off.

--
Len Sorensen
