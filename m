Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYLSG75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYLSG75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 01:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYLSG7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 01:59:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34261
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYLSG7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 01:59:45 -0500
Date: Thu, 18 Dec 2008 22:59:46 -0800 (PST)
Message-Id: <20081218.225946.98418595.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: akpm@linux-foundation.org, xemul@openvz.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] net: ppp_generic - use DEFINE_IDR for static
 initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081218154636.GB12874@localhost>
References: <20081218154636.GB12874@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Thu, 18 Dec 2008 18:46:36 +0300

> net: ppp_generic - use DEFINE_IDR for static initialization
> 
> We could use DEFINE_IDR for statically allocated idr
> that allow us to save a few lines of code.
> 
> And spell fix.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Applied, thank you.
