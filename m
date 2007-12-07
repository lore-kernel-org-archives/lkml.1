Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXLGIuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXLGIuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXLGItz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:49:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58621
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbXLGIty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:49:54 -0500
Date: Fri, 07 Dec 2007 00:49:54 -0800 (PST)
Message-Id: <20071207.004954.81492470.davem@davemloft.net>
To: crquan@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/20] net/ipv4/cipso_ipv4.c: use LIST_HEAD instead of
 LIST_HEAD_INIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <1196957076-5706-1-git-send-email-crquan@gmail.com>
References: <1196957076-5706-1-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Fri,  7 Dec 2007 00:04:36 +0800

> single list_head variable initialized with LIST_HEAD_INIT could almost
> always can be replaced with LIST_HEAD declaration, this shrinks the code
> and looks better.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Applied.
