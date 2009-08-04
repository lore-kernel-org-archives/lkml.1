Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZHDCPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZHDCPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHDCPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:15:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46679
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZHDCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:15:15 -0400
Date: Mon, 03 Aug 2009 19:15:23 -0700 (PDT)
Message-Id: <20090803.191523.60769723.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090803205954.GE11441@tuxdriver.com>
References: <20090803205954.GE11441@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 3 Aug 2009 16:59:54 -0400

> Here is another round of fixes intended for 2.6.31.  The one from
> Reinette fixes an rfkill-related bug described in bugzilla 13742.  The one
> from Luis has a lengthy changelog, but boils down to correcting some
> regulatory enforcement issues that would prevent some devices from
> working in some localities.  The rest are simple and obvious.
> 
> Please let me know if there are problems!

Pulled, thanks John.
