Return-Path: <linux-kernel-owner+w=401wt.eu-S1765122AbXJOOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765122AbXJOOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbXJOOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:01:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbXJOOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:01:49 -0400
Date: Mon, 15 Oct 2007 07:01:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion in
 EDAC drivers
Message-ID: <20071015070111.0dadf445@laptopd505.fenrus.org>
In-Reply-To: <20071015053428.GA3257@kryten>
References: <20071015053428.GA3257@kryten>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 00:34:28 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
