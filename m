Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYIBWfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYIBWfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYIBWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:35:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753339AbYIBWfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:35:33 -0400
Date: Tue, 2 Sep 2008 23:34:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: remove unused variable canon_change
Message-ID: <20080902233444.6ad91d22@lxorguk.ukuu.org.uk>
In-Reply-To: <1220390841.2137.10.camel@brick>
References: <1220390841.2137.10.camel@brick>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 14:27:21 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> drivers/char/tty_ioctl.c: In function ‘change_termios’:
> drivers/char/tty_ioctl.c:492: warning: unused variable ‘canon_change’
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Already done

Alan
