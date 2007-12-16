Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXLPK3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXLPK3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbXLPK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:29:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45188 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594AbXLPK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:29:36 -0500
Date: Sun, 16 Dec 2007 10:29:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Tosa keyboard support
Message-ID: <20071216102911.GA2307@flint.arm.linux.org.uk>
References: <20071211152318.GA8344@doriath.ww600.siemens.net> <20071211153851.GA14156@doriath.ww600.siemens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211153851.GA14156@doriath.ww600.siemens.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 06:38:51PM +0300, Dmitry Baryshkov wrote:
> Sorry, posted wrong version of patch. Here is correct version:
> 
> Support keyboard on tosa (Sharp Zaurus SL-6000x).
> Largely based on patches by Dirk Opfer.

Looks fine to me, but Dmitry Torokhov needs to look at it; he maintains
the input subsystem.  Note that the current input subsystem mailing list
is not the one you have in the CC line - please always check MAINTAINERS
for the correct addresses.

