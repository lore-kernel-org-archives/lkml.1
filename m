Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXGEWRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXGEWRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbXGEWRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:17:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3846 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbXGEWRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:17:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 5 Jul 2007 15:17:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Gautam Singaraju <gautam.singaraju@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
In-Reply-To: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707051517010.23066@alien.or.mcafeemobile.com>
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1836802438-1183673860=:23066"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1836802438-1183673860=:23066
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 5 Jul 2007, Gautam Singaraju wrote:

> I have been adding a syscall to the kernel (v 2.6.21); I am able to
> compile and boot into the kernel. However, the userspace macro fails
> to compile with the following message: "error: expected declaration
> specifiers or =E2...=E2 before =E2mycall=E2". I could not find any soluti=
on
> using google. I use the _syscall0 macro. Any suggestion would help.

Try a `man syscall`



- Davide


--1795850513-1836802438-1183673860=:23066--
