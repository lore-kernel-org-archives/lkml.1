Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYD0F3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYD0F3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYD0F3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:29:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55413
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYD0F3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:29:06 -0400
Date: Sat, 26 Apr 2008 22:29:06 -0700 (PDT)
Message-Id: <20080426.222906.193695192.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] result of csum_fold() is already 16bit, no need to cast
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427052730.GQ5882@ZenIV.linux.org.uk>
References: <20080427052730.GQ5882@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 27 Apr 2008 06:27:30 +0100

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
