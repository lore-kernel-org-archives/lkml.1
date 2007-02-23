Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbXBWO7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbXBWO7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932474AbXBWO7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:59:30 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:43335 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbXBWO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:59:28 -0500
Date: Fri, 23 Feb 2007 12:01:36 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Jon Masters <jcm@redhat.com>
Cc: Sergey Vlasov <vsu@altlinux.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mit-devel@lists.printk.net
Subject: Re: module-init-tools-3.3-pre10 available
Message-ID: <20070223120136.12ea11db@home.brethil>
In-Reply-To: <45DDAE24.6080905@redhat.com>
References: <45DD0031.9010808@redhat.com>
	<20070222170732.22c1320b.vsu@altlinux.ru>
	<45DDAE24.6080905@redhat.com>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 1.0.4 (GTK+ 1.2.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 09:52:20 -0500
Jon Masters <jcm@redhat.com> wrote:

| Sergey Vlasov wrote:
| 
| > I see that you have merged some patches which change depmod.8.
| > However, this file is generated from doc/depmod.sgml, which was not
| > changed appropriately.
| 
| Ah. A valid point - Luiz, do you want to redo your patch or I can take a 
| look at the SGML source myself.

 Urgh, I didn't know that, sorry.

 I can redo my patch, but shouldn't the manpages be removed from the
repository then?

-- 
Luiz Fernando N. Capitulino
