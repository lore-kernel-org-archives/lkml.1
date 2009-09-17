Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZIQAin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZIQAin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIQAil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:38:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:40906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753220AbZIQAik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:38:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18KctggmXUKzvVhs3YfO6g6NOahgGpLUJzv1N3O0N
	xhWB8xY+0j/+7B
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] char/hvc: adding __init macro to char/hvc_vio.c
Date: Thu, 17 Sep 2009 02:38:39 +0200
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Nicolas Palix <npalix@diku.dk>,
       Mike Frysinger <vapier@gentoo.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <200908202314.07443.PeterHuewe@gmx.de>
In-Reply-To: <200908202314.07443.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909170238.40051.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 20 August 2009 23:14:06 schrieb Peter Hüwe:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of char/hvc_vio.c
>
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial tree.
>
> linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Hi Jiri,
this one got merged by Benjamin, so you can drop it from your queue :)
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=948c28fe3001f2c9d852dff2a0b2c69fe7cec91b


@Benjamin: Thanks for merging.

Regards,
Peter
