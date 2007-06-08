Return-Path: <linux-kernel-owner+w=401wt.eu-S1031150AbXFHTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031150AbXFHTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031474AbXFHTJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:09:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:37489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031420AbXFHTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WkzW336u5d++b3FBn3XITn4+PlpO1IgKdxj+ePMrD1YFuLsL5R9TFoXeRo2B3jWqE0VoD6Y0Jg3VOylKA1WgfkMWOR4S1jiu7g07GPqiI9SMPf5e7A1t/FkVY/p8tt+uoD+vqW2rSXVStHiCsDj+oLs3HRv9Luon6616gDwdv0U=
Message-ID: <d120d5000706081208q217ca432w6cc6d860a84700e8@mail.gmail.com>
Date: Fri, 8 Jun 2007 15:08:59 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Albrecht" <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181325648.2437.5.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <200706072323.05576.dtor@insightbb.com>
	 <1181325648.2437.5.camel@albrecht.rdi1.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Paul Albrecht <albrecht@rdi1.com> wrote:
> PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> PNP: PS/2 controller doesn't have AUX irq; using default 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard as /class/input/input3

Can I please see the debug data ("i8042.debug log_buf_len=131072" on
the kernel command line)?

-- 
Dmitry
