Return-Path: <linux-kernel-owner+w=401wt.eu-S1762495AbYFDThh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495AbYFDThh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbYFDThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:37:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53477 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761926AbYFDThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:37:14 -0400
Date: Wed, 4 Jun 2008 20:20:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Fischer <rep.dot.nop@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Tim Bird <tim.bird@am.sony.com>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
Message-ID: <20080604202016.1422ec09@core>
In-Reply-To: <20080604192137.GD27768@mx.loc>
References: <48447615.5050806@am.sony.com>
	<20080604103353.GC27335@cs181133002.pp.htv.fi>
	<20080604183432.GC27768@mx.loc>
	<20080604190146.GE4189@cs181133002.pp.htv.fi>
	<20080604192137.GD27768@mx.loc>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So yes, 5k help, several 5k help more. I can see how it's problematic to
> represent that in menuconfig without adding too much clutter but still
> letting the user decide whether or not to include certain families of
> features, but that should not turn out to be a real problem.

Combinatorial explosions, ugly messes, maintenance.

Far better would be target the actual sizes and get stuff down in size
without removing feaures. There is some obvious 'easy reward' stuff here
- such as being able to build an output only console.

