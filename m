Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXFPP6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXFPP6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXFPP6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:58:36 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:18434 "EHLO
	asav14.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXFPP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:58:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsI1AKClc0ZKhRO4UGdsb2JhbACHMYd7AQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Indan Zupancic <indan@nul.nu>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Sat, 16 Jun 2007 11:58:33 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <200706152334.40387.dtor@insightbb.com> <60127.81.207.0.53.1181994857.squirrel@secure.samage.net>
In-Reply-To: <60127.81.207.0.53.1181994857.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161158.34452.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 07:54, Indan Zupancic wrote:
> 
> I applied the patch, and it compiles and runs as expected, can't lockup the
> keyboard anymore with it applied.
> 

Thank you for testing.

-- 
Dmitry
