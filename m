Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZDMWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZDMWqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDMWqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:46:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42826
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbZDMWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:46:19 -0400
Date: Mon, 13 Apr 2009 15:46:10 -0700 (PDT)
Message-Id: <20090413.154610.231691640.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kaweth: Clean up code
From: David Miller <davem@davemloft.net>
In-Reply-To: <49de2c5b.LWVli5E5/g9YVwyP%Larry.Finger@lwfinger.net>
References: <49de2c5b.LWVli5E5/g9YVwyP%Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 09 Apr 2009 12:11:55 -0500

> The driver kaweth yields a -EBUSY error when starting, and a -ETIME
> error when shutting down. These errors are avoided, and the RX status
> is further checked for other potential errors.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Applied, thanks.
