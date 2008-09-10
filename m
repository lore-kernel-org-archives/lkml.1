Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYIJJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYIJJgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYIJJgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:36:11 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33572 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYIJJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:36:10 -0400
Message-Id: <1221039369.17156.1273181435@webmail.messagingengine.com>
X-Sasl-Enc: 7NbtlzREe8dUl+WniWBr0uL65X19atK8p2+mxTTQ03xA 1221039369
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <48C73EB8.8020405@zytor.com> <20080910055337.GA9765@elte.hu>
 <48C76243.5010206@zytor.com> <20080910070014.GB31059@elte.hu>
 <20080910072455.GA12108@elte.hu>
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off
 initially
In-Reply-To: <20080910072455.GA12108@elte.hu>
Date: Wed, 10 Sep 2008 11:36:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 09:24:55 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > great - i'll check which topic this fits in best. I suspect it will 
> > get its own topic - but there could be interactions as traps*.c is a 
> > central (and hence popular) file [...]
> 
> i've put Alexander's patches into a new -git based topic: tip/x86/traps 
> - and git sorted the merge into tip/master out automatically, so this 
> will be ok logistically. The commits are below.

Great! Let's see if it works out.

Thanks,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

