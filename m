Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYD0F0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYD0F0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYD0F0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:26:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55409
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYD0F0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:26:44 -0400
Date: Sat, 26 Apr 2008 22:26:44 -0700 (PDT)
Message-Id: <20080426.222644.74393287.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: cooloney@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin checksum annotations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427052226.GP5882@ZenIV.linux.org.uk>
References: <20080427052226.GP5882@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 27 Apr 2008 06:22:26 +0100

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Since these are networking knobs and Al tends to test his
changes, I'll apply this to the net-2.6 tree.

Thanks Al!

