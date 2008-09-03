Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYICQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYICQk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYICQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:40:18 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:37803 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYICQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:40:17 -0400
Date: Wed, 3 Sep 2008 13:40:38 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903134038.63654c0a@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
	<20080903104132.7a736282@doriath.conectiva>
	<alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 3 Sep 2008 17:15:40 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Wed, 3 Sep 2008, Thomas Gleixner wrote:
| > Dont think so. Your dmesg outputs do not show any sign of that
| > disease.
| > 
| > Can you try the patch below please ?
| 
| I found another instance of possible double init/shutdown. Please add
| the patch below on top of the other 2 as well.

 No luck. I applied this patch on the top of Venki's and the last
one you sent.

 I also saw the DMAR fail message.

-- 
Luiz Fernando N. Capitulino
