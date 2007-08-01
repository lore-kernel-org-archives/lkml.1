Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXHAUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXHAUme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXHAUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:42:26 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36699 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXHAUmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:42:25 -0400
Date: Wed, 1 Aug 2007 22:42:00 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Andi Kleen <ak@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
In-Reply-To: <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0708012240210.26230@twin.jikos.cz>
References: <200708011433.09433.ak@novell.com>
 <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
 <200708012035.52863.ak@novell.com> <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Jan Engelhardt wrote:

>  config BINFMT_AOUT
> -	tristate "Kernel support for a.out and ECOFF binaries"
> +	tristate "Kernel support for a.out and ECOFF binaries (OBSOLETE)"

I beg your pardon?! This definitely is not what Andi meant, right? We want 
to remove the legacy support for a.out ELF-interpreters, not a.out 
binaries.

-- 
Jiri Kosina
