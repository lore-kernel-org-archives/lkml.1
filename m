Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYBSEp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYBSEp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYBSEpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:45:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbYBSEpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:45:13 -0500
Date: Mon, 18 Feb 2008 20:45:50 -0800 (PST)
Message-Id: <20080218.204550.03563130.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] bluetooth : do not move child device other than
 rfcomm
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080218075805.GB5940@darkstar.te-china.tietoenator.com>
References: <20080218075805.GB5940@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 18 Feb 2008 15:58:05 +0800

> hci conn child devices other than rfcomm tty should not be moved here.
> This is my lost, thanks for Barnaby's reporting and testing.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Applied, thanks Dave.
