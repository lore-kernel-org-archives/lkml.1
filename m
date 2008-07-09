Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYGIUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYGIUqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYGIUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:45:36 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51482 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYGIUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:45:35 -0400
Date: Wed, 9 Jul 2008 16:45:34 -0400
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: WAN: Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
Message-ID: <20080709204534.GF31126@csclub.uwaterloo.ca>
References: <m3r6ac3xs8.fsf@maximus.localdomain> <20080709144432.GD31126@csclub.uwaterloo.ca> <m3y74aiy9y.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3y74aiy9y.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 10:43:37PM +0200, Krzysztof Halasa wrote:
> It seems Cyclades Cyclom 2X (ISA only?) cards use the wanpipe/wanrouter
> thing for X.25. I don't know exact status, though.

Oh OK,  Nifty.  I thought it was all just sangoma stuff, but I guess if
it's in the kernel there is no reason others couldn't use bits of it
too.  Hmm, maybe the sangoma specific stuff has already been cleaned up
then although that CONFIG_WANPIPE_MULTPPP is certainly one of their
bits.

-- 
Len Sorensen
