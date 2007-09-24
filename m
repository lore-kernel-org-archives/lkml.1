Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXIXWT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXIXWT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbXIXWTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:19:45 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:49161 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbXIXWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:19:44 -0400
Subject: Re: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
	return int
From: Marcel Holtmann <marcel@holtmann.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, roel <12o3l@tiscali.nl>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       maxk@qualcomm.com
In-Reply-To: <20070924113035.GE2442@hacking>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <20070924113035.GE2442@hacking>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 00:18:07 +0200
Message-Id: <1190672287.5133.138.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

> This patch:
> - makes hidp_setup_input() return int to indicate errors;
> - checks its return value to handle errors.
> 
> And this time it is against -rc7-mm1 tree.
> 
> Thanks to roel and Marcel Holtmann for comments.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


