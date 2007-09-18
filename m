Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXIRTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXIRTlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXIRTl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:41:27 -0400
Received: from gw.goop.org ([64.81.55.164]:42914 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbXIRTl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:41:26 -0400
Message-ID: <46F029E5.9080701@goop.org>
Date: Tue, 18 Sep 2007 12:41:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Satyam Sharma <satyam@infradead.org>,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3
References: <20070918192707.GA22933@gollum.tnic>
In-Reply-To: <20070918192707.GA22933@gollum.tnic>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> +#define DMA_64BIT_MASK	~0ULL
>   

One more tiny nit: this should probably be (parenthesized).

    J
