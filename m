Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbXIYTir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbXIYTir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXIYTii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:38:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33537 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbXIYTih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:38:37 -0400
Date: Tue, 25 Sep 2007 12:38:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net, swhiteho@redhat.com
Subject: Re: [patch 1/2] menuconfig: transform NLS and DLM menus
Message-Id: <20070925123812.cb557b58.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 10:10:14 +0200 (CEST) Jan Engelhardt wrote:

> 
> Changes NLS and DLM menus into a 'menuconfig' object
> so that it can be disabled at once without having to enter
> the menu first to disable the config option.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  fs/dlm/Kconfig |    8 ++------
>  fs/nls/Kconfig |   50 +++++---------------------------------------------
>  2 files changed, 7 insertions(+), 51 deletions(-)

---
~Randy
Phaedrus says that Quality is about caring.
