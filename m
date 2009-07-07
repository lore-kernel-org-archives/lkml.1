Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZGGHMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZGGHMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZGGHMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:12:15 -0400
Received: from relay.atmel.no ([80.232.32.139]:61867 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZGGHMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:12:14 -0400
Date: Tue, 7 Jul 2009 09:12:05 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com
Subject: Re: [PATCH] dmaengine: dmatest: correct thread_count while using
 multiple thread per channel
Message-ID: <20090707091205.271359c8@hskinnemoen-d830>
In-Reply-To: <1246897184-16833-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246897184-16833-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> It seems that thread_count is not properly calculated in dmatest.
> In fact the thread count number that is returned from dmatest_add_threads() is
> not correctly added to the thread_count and thus not properly printed.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
