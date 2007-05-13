Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXEMNTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXEMNTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbXEMNSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:18:54 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:53570 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759412AbXEMNSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:18:53 -0400
Date: Sun, 13 May 2007 15:17:23 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/avr32/
Message-ID: <20070513151723.62b9f410@dhcp-252-105.norway.atmel.com>
In-Reply-To: <4644C6C3.7020000@simon.arlott.org.uk>
References: <4644C6C3.7020000@simon.arlott.org.uk>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 20:40:51 +0100
Simon Arlott <simon@fire.lp0.eu> wrote:

> Spelling fixes in arch/avr32/.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Thanks, but the comment doesn't really make sense anymore since most of
the interrupt handling logic is elsewhere. I think I'd rather just
remove it.

Haavard
