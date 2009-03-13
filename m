Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbZCMVaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbZCMVaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbZCMVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:30:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52149
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755700AbZCMVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:30:46 -0400
Date: Fri, 13 Mar 2009 14:30:31 -0700 (PDT)
Message-Id: <20090313.143031.203900595.davem@davemloft.net>
To: scott@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/31] sbus: Auto-load openprom module when device
 opened.
From: David Miller <davem@davemloft.net>
In-Reply-To: <096a96f38cc7226c591686098ea30fe29a4a84fb.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<096a96f38cc7226c591686098ea30fe29a4a84fb.1236702228.git.scott@canonical.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:23:13 +0000

> The openprom module is missing the char-major-10-139 alias that would
> cause it to be auto-loaded when a device of that type is opened.  This
> patch adds the alias.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Although I am sure you didn't test this, this patch is actually
correct so applied.

Thanks.
