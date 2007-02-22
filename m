Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbXBVOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbXBVOxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbXBVOxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:53:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbXBVOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:53:41 -0500
Message-ID: <45DDAE24.6080905@redhat.com>
Date: Thu, 22 Feb 2007 09:52:20 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sergey Vlasov <vsu@altlinux.ru>
CC: "Luiz Fernando N.Capitulino" <lcapitulino@mandriva.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mit-devel@lists.printk.net
Subject: Re: module-init-tools-3.3-pre10 available
References: <45DD0031.9010808@redhat.com> <20070222170732.22c1320b.vsu@altlinux.ru>
In-Reply-To: <20070222170732.22c1320b.vsu@altlinux.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Vlasov wrote:

> I see that you have merged some patches which change depmod.8.
> However, this file is generated from doc/depmod.sgml, which was not
> changed appropriately.

Ah. A valid point - Luiz, do you want to redo your patch or I can take a 
look at the SGML source myself.

Jon.
