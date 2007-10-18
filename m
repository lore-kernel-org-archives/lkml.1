Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbXJRC3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbXJRC3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXJRC3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:29:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59580
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759154AbXJRC3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:29:07 -0400
Date: Wed, 17 Oct 2007 19:29:06 -0700 (PDT)
Message-Id: <20071017.192906.112623207.davem@davemloft.net>
To: chardin@2wire.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pfkey: sending an SADB_GET responds with an SADB_GET
From: David Miller <davem@davemloft.net>
In-Reply-To: <C33BCE5A.25D04%chardin@2wire.com>
References: <C33BCE5A.25D04%chardin@2wire.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Hardin <chardin@2wire.com>
Date: Wed, 17 Oct 2007 14:36:10 -0700

> Kernel needs to respond to an SADB_GET with the same message type to conform
> to the RFC 2367 Section 3.1.5

I can't apply this:

1) We need you to provide an appropriate Signed-off-by: line
   in the changelog of your patch.

2) Your email client corrupted the patch, changing tabs into spaces,
   and adding newline breaks to long lines.

Please resubmit with these two errors corrected, thank you.
