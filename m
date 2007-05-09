Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXEIMmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXEIMmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXEIMmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:42:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41511 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXEIMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:42:14 -0400
Date: Wed, 9 May 2007 14:42:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de,
       jmorris@namei.org
Subject: Re: [patch 7/9] lguest: the net driver
Message-ID: <20070509124211.GG17482@one.firstfloor.org>
References: <200705090951.l499pdOr020406@shell0.pdx.osdl.net> <4641BE65.3030807@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641BE65.3030807@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> __pa() should not be used in any driver.

Besides that was always not supposed to work. RELOC_HIDE or __pa_symbol.

-Andi
