Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbZDXXKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbZDXXKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbZDXXK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:10:28 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:46031 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbZDXXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:10:26 -0400
Date: Fri, 24 Apr 2009 20:09:28 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc3][Regression] Compilation failure: undefined
	reference to `acpi_video_register'
Message-ID: <20090424230928.GC7858@ime.usp.br>
References: <20090424091412.GA15074@ime.usp.br> <alpine.LFD.2.00.0904241445430.10096@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0904241445430.10096@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len.

On Apr 24 2009, Len Brown wrote:
> Rogério Brito:
> > (.text+0x87d2e): undefined reference to `acpi_video_register'
> 
> try this:
> 
> http://patchwork.kernel.org/patch/19821/

Still got the very same error after applying the patch.

Reading it, I saw that it regarded the modesetting being enabled. I
don't have it selected on my system. Is there anything else that I could
try?


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
