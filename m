Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbXHJHzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbXHJHzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXHJHzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:55:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:52109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbXHJHzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:55:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: EFI e820 map handling
Date: Fri, 10 Aug 2007 09:55:17 +0200
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
References: <200708091206.37302.ak@suse.de> <86802c440708092211y513f5dd2rd27310b626a7f0c2@mail.gmail.com>
In-Reply-To: <86802c440708092211y513f5dd2rd27310b626a7f0c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708100955.17996.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> How about elilo to load freebsd or opensolaris?

I don't know. How is that related? The current lilo can't load them either.
Supposedly they could write their own EFI boot loaders

-Andi
