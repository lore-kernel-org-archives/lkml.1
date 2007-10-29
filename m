Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbXJ2QLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbXJ2QLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXJ2QLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:11:33 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58627 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754093AbXJ2QLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:11:32 -0400
Date: Mon, 29 Oct 2007 17:11:20 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA: Fix broken device refcounting
Message-ID: <20071029171120.587d2bac@dhcp-255-175.norway.atmel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C034FF787@orsmsx418.amr.corp.intel.com>
References: <1193415162504-git-send-email-hskinnemoen@atmel.com>
	<1193416577.9353.5.camel@dwillia2-linux.ch.intel.com>
	<20071027154947.6836a3d9@siona>
	<1193512357.18911.6.camel@dwillia2-linux.ch.intel.com>
	<BAE9DCEF64577A439B3A37F36F9B691C034FF787@orsmsx418.amr.corp.intel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 09:02:34 -0700
"Nelson, Shannon" <shannon.nelson@intel.com> wrote:

> I tested this in my ioatdma setup and no longer get the panic.  I'm good with this if you two are happy with it.  

Looks good to me too, although I haven't had a chance to test it yet.

Thanks,
Håvard
