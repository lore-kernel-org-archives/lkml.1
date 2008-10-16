Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYJPRdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYJPRdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbYJPRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:30:20 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:50200 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003AbYJPRaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:30:18 -0400
Date: Fri, 17 Oct 2008 02:30:24 +0900 (JST)
Message-Id: <20081017.023024.132760073.anemo@mba.ocn.ne.jp>
To: sshtylyov@ru.mvista.com
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org, bzolnier@gmail.com,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc allmodconfig
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <48F7159D.4040709@ru.mvista.com>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	<48F7159D.4040709@ru.mvista.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 14:21:17 +0400, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> > drivers/serial/serial_txx9.c: In function 'serial_txx9_probe':
> > drivers/serial/serial_txx9.c:1041: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
> >   
> 
>    Atsushi-san, are you seeing this one?

Yes, I'll send a one-liner patch soon.

---
Atsushi Nemoto
