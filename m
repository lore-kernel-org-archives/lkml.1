Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZK3QMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZK3QMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZK3QMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:12:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:60564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752513AbZK3QMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:12:31 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+7vDxwY0q7DNpd9sCpktDIlqqqUeolFbi969VRBG
	2krxGEALttjIQs
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: a.out.h contains special chars
Date: Mon, 30 Nov 2009 17:12:35 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911301712.35220.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading this mail :

>From: liu weni <qingshenlwy <at> gmail.com>
>Subject: [PATCH]a.out.h: Fix the format error.
>Newsgroups: gmane.linux.kernel
>Date: 2009-11-29 00:19:40 GMT (1 day, 15 hours and 49 minutes ago)
>
>------
>rm the symbol of ^L in the include/linux/a.out.h.

I'm wondering why the difference betweenthe file a.out.h and the output of
`strings a.out.h` has a lot more differences wrt the braces "{" and "};".

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

