Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbXHENOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbXHENOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 09:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXHENOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 09:14:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37472 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbXHENOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 09:14:14 -0400
Date: Sun, 5 Aug 2007 15:14:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langaas@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Disassembling a binary-only kernel module
In-Reply-To: <6264d2ec0708050544m2b74f480q8b9dcdadca92c600@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708051513560.29913@fbirervta.pbzchgretzou.qr>
References: <6264d2ec0708050544m2b74f480q8b9dcdadca92c600@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-82717898-1186319653=:29913"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-82717898-1186319653=:29913
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 5 2007 14:44, Thomas Langås wrote:
>
>Please CC me, as I'm not subscribed to the list.
>
>I've got a binary-only kernel module for a box I own (PowerPC-based),
>and I want to
>disassemble the module but I don't know much about tools for linux for
>doing this.
>
>So, what I'm asking about is just a few pointers in which tools I should use for
>the process.  (I've done a readelf for the initial insight on the module).

like, objdump -DS foo.ko?


	Jan
-- 
---699020219-82717898-1186319653=:29913--
