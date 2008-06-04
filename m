Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYFDVhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYFDVhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFDVho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:37:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56422
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYFDVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:37:43 -0400
Date: Wed, 04 Jun 2008 14:37:43 -0700 (PDT)
Message-Id: <20080604.143743.193705192.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
From: David Miller <davem@davemloft.net>
In-Reply-To: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
References: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Wed, 4 Jun 2008 15:38:22 -0500

> You seem to be the last person to touch the math-emu code in the  
> kernel so I figured you might have some insights.  I'm trying to move  
> the powerpc math-emu code to use the include/math-emu bits.

I'll try to look at this after I'm done with my current 3 week
stint of travelling, but right now I really don't have time for
stuff like this.

I tried running TestFloat a couple weeks ago but I couldn't
get the damn thing to even build properly after fighting with
it for what seemed like hours :-/  I'll try again at some point.
