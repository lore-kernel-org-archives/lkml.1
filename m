Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYCZLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYCZLsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYCZLsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:48:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40167
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbYCZLsG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:48:06 -0400
Date: Wed, 26 Mar 2008 04:48:02 -0700 (PDT)
Message-Id: <20080326.044802.107678511.davem@davemloft.net>
To: joern@logfs.org
Cc: mingo@elte.hu, apw@shadowen.org, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080326114142.GD22847@logfs.org>
References: <20080326102654.GB22847@logfs.org>
	<20080326112311.GG17176@elte.hu>
	<20080326114142.GD22847@logfs.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jörn Engel <joern@logfs.org>
Date: Wed, 26 Mar 2008 12:41:42 +0100

> Do you have a non-consistency based reason to prefer the longer
> version?

Inconstent spacing fools people's eyes and leads to bugs,
more often than not.

After 15 years of kernel development, I can remember at
least 10 or so multi-week-debugging sessions that could
have been curtailed had I not mis-read a poorly spaced
C statement.

It matters in practical terms, not just consistency terms,
trust me.
