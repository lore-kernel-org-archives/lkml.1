Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYBQUy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYBQUy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYBQUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:54:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYBQUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:54:48 -0500
Date: Sun, 17 Feb 2008 12:54:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com
Subject: Re: getting uninterruptible sleep processes after upgrade from
 2.6.20.20 to 2.6.24.2
Message-ID: <20080217125407.5b76a052@laptopd505.fenrus.org>
In-Reply-To: <47B89DC6.4070906@allied-internet.ag>
References: <47B892B9.7060205@allied-internet.ag>
	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>
	<47B89DC6.4070906@allied-internet.ag>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 21:49:10 +0100
allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag> wrote:

>  >> One week ago we upgraded about 300 servers from 2.6.20.20 to
>  >> 2.6.24.2.
>  >
>  > Painfull.
> 
> OK not really - i've tested the new kernel on all models. And it
> works fine... the DN state only comes sometimes - absolutely not
> reproducable. So my tests went OK and then we've done the update.
> I've now seen 5 servers in 7 days having this problem.
> 
>  >> Now we get sometimes dozent of processes in state DN. The system
>  >> is completely idle - but the load is 20 or 90 or whatever. And it
>  >> can only be "repaired" by rebooting the system.
>  >
>  > please post sysrq-t (echo t > /proc/sysrq-trigger) output.
> Sorry what key is sysrq? Can i also do this via SSH Console?

just do the echo above and it'll have the same effect as the key, and yes
you can do this via ssh just fine (I do that all the time)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
