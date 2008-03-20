Return-Path: <linux-kernel-owner+w=401wt.eu-S1163285AbYCTAc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163285AbYCTAc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943721AbYCTACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:02:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44571
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S943712AbYCTAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:01:58 -0400
Date: Wed, 19 Mar 2008 17:02:14 -0700 (PDT)
Message-Id: <20080319.170214.201993790.davem@davemloft.net>
To: luciano@eurotux.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: target headers_install: no linux/if_addrlabel.h (2.6.24.3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080318152437.GA29674@bit.office.eurotux.com>
References: <20080318152437.GA29674@bit.office.eurotux.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luciano Rocha <luciano@eurotux.com>
Date: Tue, 18 Mar 2008 15:24:37 +0000

> 
> Hello,
> 
> I've compiled Linux 2.6.24.3 for arm, using gcc 4.3.0, and I get the
> following error when trying to extract the kernel headers. Is this
> known, or do I have a problem with my configuration?

Simply remove the if_addrlabel.h line from include/linux/Kbuild,
this will be fixed in a future 2.6.24.x release
