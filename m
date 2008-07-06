Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbYGFSAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbYGFSAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYGFR75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:59:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61411 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYGFR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:59:56 -0400
Date: Sun, 6 Jul 2008 10:58:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 setup.c: cleanup includes
Message-Id: <20080706105840.90ac5219.randy.dunlap@oracle.com>
In-Reply-To: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
References: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 20:13:49 +0400 Alexander Beregalov wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> The patch applies to the linux-next tree.
> 
> 
> x86: remove double includes in setup.c

Hi,

Did you do these manually (by personal inspection) or by some tool?
If a tool, what tool/where is it?  Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
