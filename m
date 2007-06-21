Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXFUTLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXFUTLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXFUTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:11:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:22566 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXFUTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:11:30 -0400
Date: Thu, 21 Jun 2007 21:11:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kandziora <jjj@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Limiting load of certain processes
In-Reply-To: <200706212100.28381.jjj@gmx.de>
Message-ID: <Pine.LNX.4.64.0706212110440.26568@fbirervta.pbzchgretzou.qr>
References: <200706211950.40825.jjj@gmx.de> <Pine.LNX.4.64.0706212020520.26568@fbirervta.pbzchgretzou.qr>
 <200706212100.28381.jjj@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 21 2007 21:00, Jan Kandziora wrote:

>I know it's a crude idea for everyday Linux processes, but for
>dosemu driven applications, which behave badly in a multitasking OS
>*and* for which source code isn't available, it may be worth to
>discuss.

Would dosbox do? (it does busy-loops too, but at least, it's got
source)


	Jan
-- 
