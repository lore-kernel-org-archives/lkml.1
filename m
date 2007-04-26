Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXDZVcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXDZVcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXDZVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:32:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41904
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbXDZVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:32:04 -0400
Date: Thu, 26 Apr 2007 14:32:11 -0700 (PDT)
Message-Id: <20070426.143211.34758786.davem@davemloft.net>
To: vsu@altlinux.ru
Cc: gregkh@suse.de, yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: "IPV6: Disallow RH0 by default" patch looks broken
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070426202157.e357ece5.vsu@altlinux.ru>
References: <20070426072441.GA5515@kroah.com>
	<20070426072503.GA5643@kroah.com>
	<20070426202157.e357ece5.vsu@altlinux.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Vlasov <vsu@altlinux.ru>
Date: Thu, 26 Apr 2007 20:21:57 +0400

> I suppose "case IPV6_SRCRT_TYPE_2:" is missing before "break"?
> 
> The same broken patch went in 2.6.21.

Yes, I already discussed this in private email with Yoshifuji and
he sent me a fix which I'll push around.
