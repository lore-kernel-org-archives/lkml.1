Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYCXFuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYCXFuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 01:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYCXFub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 01:50:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37395
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbYCXFua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 01:50:30 -0400
Date: Sun, 23 Mar 2008 22:50:30 -0700 (PDT)
Message-Id: <20080323.225030.162295343.davem@davemloft.net>
To: roland@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64 exec PT_DTRACE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080323211951.522C026FA0A@magilla.localdomain>
References: <20080323211951.522C026FA0A@magilla.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Sun, 23 Mar 2008 14:19:51 -0700 (PDT)

> The PT_DTRACE flag is meaningless and obsolete.
> Don't touch it.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Applied, thanks Roland.
