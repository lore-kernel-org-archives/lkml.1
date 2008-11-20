Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYKTPYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYKTPYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYKTPYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:24:37 -0500
Received: from mail.atmel.fr ([81.80.104.162]:51271 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbYKTPYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:24:36 -0500
Message-ID: <49257C13.2080304@atmel.com>
Date: Thu, 20 Nov 2008 16:02:43 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
References: <200810271426.27110.david-b@pacbell.net><4921394E.2000901@atmel.com> <20081119194517.2b73d74f@mjolnir.drzeus.cx>
In-Reply-To: <20081119194517.2b73d74f@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Mon, 17 Nov 2008 10:28:46 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
> 
> Any side-effects besides from dmesg noise? IOW should I push for .28?

No side-effect. I advice you to push it for .28-final.

Kind regards,
-- 
Nicolas Ferre

