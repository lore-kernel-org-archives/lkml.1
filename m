Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYFESV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYFESV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYFESVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:21:47 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:38928 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYFESVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:21:46 -0400
Message-Id: <200806051820.m55IKqp0031852@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: Giuliano Procida <gprocida@marge.com>,
       linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Subject: Re: [PATCH] firmware: convert Ambassador ATM driver to request_firmware()
In-reply-to: <1212689632.32207.283.camel@pmac.infradead.org>
Date: Thu, 05 Jun 2008 14:20:52 -0400
X-NRLCMF-Spam-Score: () hits=-0.135
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1212689632.32207.283.camel@pmac.infradead.org>,David Woodhouse writ
es:
>For now, I'm keen to keep the firmware within the kernel, in the
>firmware/ directory where it can be included directly with no
>'regressions'. I don't want the potential debate about firmware being in
>the kernel tree to get in the way of the real cleanups -- so if it's OK
>with you, I'll apply your patch and also move the firmware into the
>firmware/ directory?

it would need to be converted to the binary form first, or the patch
will need to rewritten to use the s-record format.
