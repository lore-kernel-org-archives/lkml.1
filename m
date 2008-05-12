Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYELQJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYELQJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYELQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:09:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:18077 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYELQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:09:36 -0400
Subject: Re: [PATCH] ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
From: Daniel Walker <dwalker@mvista.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080505203154.GF11462@traven>
References: <20080505203154.GF11462@traven>
Content-Type: text/plain
Date: Mon, 12 May 2008 09:09:31 -0700
Message-Id: <1210608572.22306.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 22:31 +0200, Matthias Kaehlcke wrote:
> ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
> mutex. Convert it to the mutex API
> 

I submitted an identical patch to Tony in January .. I assumed it was
making it's way through the ARM tree .. I'm surprised it's not in
mainline yet ..

Tony any status on this?

Daniel

