Return-Path: <linux-kernel-owner+w=401wt.eu-S1765155AbXHFPkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765155AbXHFPkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764367AbXHFPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:40:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52148 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbXHFPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:40:29 -0400
Date: Mon, 6 Aug 2007 17:40:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> 
 <1186317610.5220.3.camel@daplas> <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-503937590-1186414828=:13469"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-503937590-1186414828=:13469
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 5 2007 21:26, Jeff Chua wrote:
>Here's what see when I "cat /dev/vcs1" ...
>
>            ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
>
>The pattern repeats and fill the whole screen.

That looks pretty much like all-one-bits (ÿ = 255).
What about vcsa1 (use hexdump -C)?


	Jan
-- 
---699020219-503937590-1186414828=:13469--
