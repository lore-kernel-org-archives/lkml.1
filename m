Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIBXk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIBXk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYIBXkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:40:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38844
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbYIBXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:40:48 -0400
Date: Tue, 02 Sep 2008 16:40:42 -0700 (PDT)
Message-Id: <20080902.164042.147785415.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: alan@redhat.com, sparclinux@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [next 0902] sparc64: oops at boot: n_tty_set_termios
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670809020908t4f763557l306a1db791677f8d@mail.gmail.com>
References: <a4423d670809020908t4f763557l306a1db791677f8d@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Tue, 2 Sep 2008 20:08:09 +0400

> Hi
> 
> Host is Sun Ultra 10.
> 
> Here is what can I see on screen:
> 
> swapper(1): Oops
> 
> TPC: n_tty_set_termios
> i7: n_tty_open

Alan says he pushed a fix for this, see the thread titled:
"Re: broken tty-move-canon-specials patch"
