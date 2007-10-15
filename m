Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbXJOOC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbXJOOC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbXJOOCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:02:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbXJOOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:02:17 -0400
Date: Mon, 15 Oct 2007 07:01:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: yi.zhu@intel.com, jketreno@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
 ipw2100/ipw2200
Message-ID: <20071015070136.2cea656d@laptopd505.fenrus.org>
In-Reply-To: <20071015053801.GB3257@kryten>
References: <20071015053428.GA3257@kryten>
	<20071015053801.GB3257@kryten>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 00:38:01 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
