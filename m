Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZGVDqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZGVDqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZGVDqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:46:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42704
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940AbZGVDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:45:59 -0400
Date: Tue, 21 Jul 2009 20:46:05 -0700 (PDT)
Message-Id: <20090721.204605.119697841.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ide-tape: convert to ide_debug_log macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247910917-5237-3-git-send-email-petkovbb@gmail.com>
References: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
	<1247910917-5237-3-git-send-email-petkovbb@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Sat, 18 Jul 2009 11:55:16 +0200

> Remove tape->debug_mask and use drive->debug_mask instead.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Applied.
