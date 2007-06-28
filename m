Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXF1Wm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXF1Wm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764917AbXF1WmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:42:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47090 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755669AbXF1WmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:42:20 -0400
Date: Thu, 28 Jun 2007 23:48:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070628234807.4c446062@the-village.bc.nu>
In-Reply-To: <46842F7B.1010105@gmail.com>
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>
	<oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>
	<4683983E.5020103@aitel.hist.no>
	<4683D3B0.1040708@beezmo.com>
	<20070628173051.4a3422c0@the-village.bc.nu>
	<46842F7B.1010105@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 00:00:27 +0200
Rene Herman <rene.herman@gmail.com> wrote:

> On 06/28/2007 06:30 PM, Alan Cox wrote:
> 
> > Public domain is GPL compatible.
> 
> Would you happen to have an opinion on the attached? I don't so much need it 

The answer is "NO!!!!"

Public domain also means "I don't have to give you the source".
If its merged with the kernel the resulting work is GPL anyway

> Stating that code which one intends to be in the public domain has "GPL and 
> additional rights" is a bit of a travesty though.

Indeed if its public domain you may have almost no rights at all
depending what you were given. Once you get the source code you can do
stuff but I don't have to give you that. If its public domain I can find
security holes in it, and refuse to provide the fixed module in source
form even.

(And public domain is a pretty 'brave' choice of licence as in many
countries it does not imply any of the no warranty stuf the GPL does).

So essentially, if its public domain and you put a copy in the kernel GPL
the kernel copy. It doesn't mean the PD version ceased to be PD. If you
want to keep it PD then also ask that anyone contributing to the GPL
version also sends you a PD version of any changes. (They may not but
then right now they dont have to anyway)

Alan
