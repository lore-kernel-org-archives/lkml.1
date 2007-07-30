Return-Path: <linux-kernel-owner+w=401wt.eu-S968822AbXG3V4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968822AbXG3V4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938298AbXG3V42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:56:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbXG3V41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:56:27 -0400
Date: Tue, 31 Jul 2007 03:38:37 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Adrian Bunk <bunk@stusta.de>
cc: ian <spyro@f2s.com>, Andrew Morton <akpm@linux-foundation.org>,
       john@dnsworld.co.uk, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [2.6 patch] Remove the arm26 port
In-Reply-To: <20070730114914.GN16817@stusta.de>
Message-ID: <alpine.LFD.0.999.0707310333050.17287@enigma.security.iitk.ac.in>
References: <20070707201208.GJ3492@stusta.de> <20070729115040.GD30976@stusta.de>
 <1185749926.2305.16.camel@wirenth> <20070730114914.GN16817@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Adrian Bunk wrote:

> The arm26 port has been in a state where it was far from even compiling 
> for quite some time.
> 
> Ian Molton agreed with the removal.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Due to its size, the patch is attached compressed.

You could've submitted a git patch. Would've been smaller and easier
to apply, I think.

>  248 files changed, 9 insertions(+), 35817 deletions(-)

Amazing :-)

[ Do you realize you were ~36 times more productive than
  one of Ken Thompson's most productive days, just now? ]
