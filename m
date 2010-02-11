Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab0BKFbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 00:31:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:50020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0BKFbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 00:31:31 -0500
Subject: Re: register long sp asm("r1") incorrect
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 16:31:13 +1100
Message-ID: <1265866273.16346.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 16:24 +0100, Pavel Machek wrote:
> ...according to gcc docs, sp should be global, or placement in
> register is not guaranteed (except at asm boundaries, but there are
> none).

Sorry I'm not sure I grok what you mean.

Cheers,
Ben.


