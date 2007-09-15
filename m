Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbXIOPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbXIOPis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXIOPil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:38:41 -0400
Received: from tag.witbe.net ([81.88.96.48]:56097 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXIOPik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:38:40 -0400
Date: Sat, 15 Sep 2007 17:38:34 +0200
From: Paul Rolland <rol@as2917.net>
To: eric.valette@free.fr
Cc: flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
Message-ID: <20070915173834.4fbfe9d5@tux.DEF.witbe.net>
In-Reply-To: <46EBEBD2.7060502@free.fr>
References: <46EBE70C.2040201@free.fr>
	<46EBEBD2.7060502@free.fr>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sat, 15 Sep 2007 16:27:30 +0200
Eric Valette <eric.valette@free.fr> wrote:

> Eric Valette wrote:
> 
> > I can probably take a picture of the backtrace if you want.
> 
> Just saw that just above my message in the LKML web interface, someone
> posted a backtrace. Mine is different but at least, we are at least two
> to have the crash.

Well, I have it when compiling rtl8187 inside the kernel, but I still have to
try it as a module, to confirm we are facing the same bug...

Please allow me some time for that, I'll post an update.

Regards,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
