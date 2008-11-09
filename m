Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYKIIlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYKIIlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 03:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYKIIlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 03:41:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:55784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751195AbYKIIlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 03:41:23 -0500
X-Authenticated: #36613700
X-Provags-ID: V01U2FsdGVkX18N4UJvhNANpdnwC5xilfLehfHSYqb4u7Aspyo9w2
	NPwLwdOE8r1mE7
From: Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de>
Reply-To: mathias.schnarrenberger@gmx.de
To: "Olaf van der Spek" <olafvdspek@gmail.com>
Subject: Re: security: delete BIOS password in keyboard buffer during kernel bootup
Date: Sun, 9 Nov 2008 09:41:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200811081100.03966.mathias.schnarrenberger@gmx.de> <b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
In-Reply-To: <b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811090941.20401.mathias.schnarrenberger@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if my BIOS stores some critical info at that memory address?
> I don't think the kernel is the right place to work around this issue.

AFAIK every IBM PC compatible BIOS stores the keyboard buffer in this area.

Mathias
