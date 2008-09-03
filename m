Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYICNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYICNid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbYICNiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:38:23 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:34188 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYICNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:38:22 -0400
Date: Wed, 3 Sep 2008 10:38:44 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: Thomas Gleixner <tglx@linutronix.de>, herton@mandriva.com.br,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903103844.60c8f6fd@doriath.conectiva>
In-Reply-To: <20080902204058.GB17488@motherbox.xtech.com.ar>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902204058.GB17488@motherbox.xtech.com.ar>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 2 Sep 2008 17:40:58 -0300
Diego Woitasen <diego@woitasen.com.ar> escreveu:

| I'm not sure if it's related, but I have similar problems with
| CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS. With the second one, the kernel
| shoot a kernel panic during the boot and with both enabled or with
| CONFIG_NO_HZ only crash after a while.

 I don't think it's the same bug because the bug we're talking about
can only be triggered after 2.6.27-rc1.

 Can you attach your lspci -vv and you cpuinfo so that I check whether
I have the same machine here?

 Bisecting would be very useful, btw. 

-- 
Luiz Fernando N. Capitulino
