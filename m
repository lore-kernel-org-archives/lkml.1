Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXFOXW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXFOXW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXFOXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:22:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53945 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755901AbXFOXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:22:18 -0400
Date: Sat, 16 Jun 2007 00:26:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: john.blackwood@ccur.com, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
Subject: Re: [RFC] [PATCH] selective signal ptracing
Message-ID: <20070616002615.7c727d75@the-village.bc.nu>
In-Reply-To: <20070615194229.AF0984D059F@magilla.localdomain>
References: <4672A2ED.6030401@ccur.com>
	<20070615194229.AF0984D059F@magilla.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 12:42:29 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> I am not in favor of any enhancements to the ptrace interface.
> It is a terrible interface and just needs to die.

That might make sense if utrace ever looked like it would solve the
questions about platforms like ARM
