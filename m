Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXJIWAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXJIWAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXJIWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:00:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52826
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXJIWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:00:40 -0400
Date: Tue, 09 Oct 2007 15:00:40 -0700 (PDT)
Message-Id: <20071009.150040.55724885.davem@davemloft.net>
To: david-b@pacbell.net
Cc: stern@rowland.harvard.edu, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710091443.54998.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
	<20071009.142719.68041626.davem@davemloft.net>
	<200710091443.54998.david-b@pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Tue, 9 Oct 2007 14:43:54 -0700

> Does it resolve the problem you observed?

I will definitely give the patch a try and report back.
