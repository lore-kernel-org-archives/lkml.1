Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXJDNbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXJDNbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 09:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXJDNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 09:31:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42686 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXJDNa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 09:30:59 -0400
Date: Thu, 4 Oct 2007 06:28:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, jikos@jikos.cz
Subject: Re: video resume stuff
Message-ID: <20071004062848.0c55d182@laptopd505.fenrus.org>
In-Reply-To: <20071004130513.GA16076@elf.ucw.cz>
References: <20071004130513.GA16076@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 15:05:13 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> I'm thinking about how to clean up video resume/how to get it to work
> for non-VESA video modes (jikos' case).


I suspect in the medium run, the video mode setting stuff that's moving
into the kernel is the real answer to this problem... maybe it's more
efficient to move that in in a hurry ;)
