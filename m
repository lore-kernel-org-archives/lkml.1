Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZD3DMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZD3DMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZD3DMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:12:00 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50794 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbZD3DL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:11:59 -0400
X-Sasl-enc: Qvks2eYAHIsho37ed9uNcqLDC8G00l2V1JUDNGEAgVzE 1241061118
Date: Thu, 30 Apr 2009 00:11:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mao Yilu <ylmao@mail.ustc.edu.cn>
Cc: "'Robert Hancock'" <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: TSC unstable on Intel Pentium M processor 750
Message-ID: <20090430031155.GC18827@khazad-dum.debian.net>
References: <440758024.12507@ustc.edu.cn> <441049102.10204@ustc.edu.cn> <654E14825BCE4C9B94E5986000DC9BCE@xiaomao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654E14825BCE4C9B94E5986000DC9BCE@xiaomao>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Mao Yilu wrote:
> But I still don't know why the TSC is not correct in the C1 state (hlt
> instruction). Is there anything more to influence the TSC? What happened
> when the CPU is not running under hlt instruction?

SMIs?  Laptops love that crap...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
