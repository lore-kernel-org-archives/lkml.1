Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXEORln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXEORln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXEORle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:41:34 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34527 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756230AbXEORld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:41:33 -0400
Date: Tue, 15 May 2007 18:43:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: select(0, ..) is valid ?
Message-ID: <20070515184345.0431d80e@the-village.bc.nu>
In-Reply-To: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 10:29:18 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Hi,
> 
> Is select(0, ..) is a valid operation ?

Yes. It's a fairly classic old BSD way to do timeouts

Alan
