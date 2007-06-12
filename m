Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXFLXgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXFLXgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbXFLXgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:36:17 -0400
Received: from neon.samage.net ([85.17.153.66]:34935 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXFLXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:36:16 -0400
Message-ID: <52481.81.207.0.53.1181691356.squirrel@secure.samage.net>
In-Reply-To: <200706120142.13173.dtor@insightbb.com>
References: <20070604112426.GA2707@elf.ucw.cz>
    <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com>
    <20070604205701.GD2711@elf.ucw.cz>
    <200706120142.13173.dtor@insightbb.com>
Date: Wed, 13 Jun 2007 01:35:56 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Andi Kleen" <ak@suse.de>, "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 63767ed6f001c63471f2cde26909bd9c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, June 12, 2007 07:42, Dmitry Torokhov wrote:
> For what it worth I finally tried that setleds loop on my laptop. I am
> not getting any lost keypresses/releases. But then I don't have EC
> (or at least it is not exported via ACPI). This is an old Dell notebook.

Well, as I said before, I've the "stuck key"/repeated output too (as well
as a warping PS/2 mouse), but no blinking led problem, so I believe the
two things are totally unrelated.

Greetings,

Indan


