Return-Path: <linux-kernel-owner+w=401wt.eu-S1031027AbXDPXlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031027AbXDPXlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031031AbXDPXlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:41:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031027AbXDPXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:41:09 -0400
Date: Mon, 16 Apr 2007 16:41:11 -0700 (PDT)
Message-Id: <20070416.164111.32625690.davem@davemloft.net>
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070416232851.GA15840@dmccrory-d810.qlogic.org>
References: <20070416222517.GD14351@andrew-vasquezs-computer.local>
	<20070416.152910.107940079.davem@davemloft.net>
	<20070416232851.GA15840@dmccrory-d810.qlogic.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 16:28:51 -0700

> Sorry, but let's be realistic, this type of warning would have
> *NEVER* been addressed if we kept the status quo

Wrong.  I watch the logs all the time and would have sent you a fix to
use the Sparc firmware info as soon as I saw the kernel log message.

Anyone who has worked with me over the last 15 years will let you know
emphatically that this is true.

AND IN THE MEAN TIME I COULD GET WORK DONE AND MY SYSTEM WOULD BOOT!
