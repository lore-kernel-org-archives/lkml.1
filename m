Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbYBGAfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbYBGAfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932793AbYBGACE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:02:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbYBGACB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:02:01 -0500
Date: Wed, 06 Feb 2008 16:02:31 -0800 (PST)
Message-Id: <20080206.160231.45881964.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080206235902.GA15719@suse.de>
References: <20080206233117.GA28931@suse.de>
	<20080206.153714.133821225.davem@davemloft.net>
	<20080206235902.GA15719@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 15:59:02 -0800

> What block drivers are you using for sparc?  Scsi?  Or something else?
> What could make sparc64 different from x86 in regards to block device
> structure, odd...

Only Fusion SAS on this system, therefore scsi.
