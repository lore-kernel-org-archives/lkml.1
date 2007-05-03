Return-Path: <linux-kernel-owner+w=401wt.eu-S1161806AbXECK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161806AbXECK1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161798AbXECK1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:27:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161785AbXECK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:27:48 -0400
Date: Thu, 03 May 2007 03:27:49 -0700 (PDT)
Message-Id: <20070503.032749.63487512.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH 2/5] [AFS]: Fix memory leak in SRXAFSCB_GetCapabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070503095320.26912.67210.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
	<20070503095320.26912.67210.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 03 May 2007 10:53:20 +0100

> The interface array is not freed on exit.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks.
