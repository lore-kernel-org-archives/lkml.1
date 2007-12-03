Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXLCQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXLCQDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXLCQDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:03:40 -0500
Received: from homer.mvista.com ([63.81.120.158]:8703 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbXLCQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:03:40 -0500
Subject: Re: [PATCH] isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org
In-Reply-To: <20071203155753.GA32546@elte.hu>
References: <20071203153743.119714913@mvista.com>
	 <20071203155753.GA32546@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 07:52:24 -0800
Message-Id: <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 16:57 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Changed the isapnp semaphore to a mutex.
> 
> cool - i'll give it a whirl.
> 
> small immaterial nit:
> 
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> it's Signed-off-by (note the capitalization). Having this consistent 
> makes scripting around patches a tiny bit easier.

Yeah, I know about it but sometimes still slips by..

Daniel

