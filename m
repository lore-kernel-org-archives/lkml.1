Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbXIJRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbXIJRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbXIJRli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:41:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXIJRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:41:38 -0400
Date: Mon, 10 Sep 2007 19:41:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
In-Reply-To: <20070910102259.dc45a481.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709101940270.5368@fbirervta.pbzchgretzou.qr>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
 <20070910172334.GB19100@linux.vnet.ibm.com> <20070910102259.dc45a481.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 10:22, Andrew Morton wrote:
>> Unless folks have strong objection to it, I prefer "cptctlr", the way it is.
>
>Kernel code is write-rarely, read-often.

I think you mean __read_mostly. :-)




	Jan
-- 
