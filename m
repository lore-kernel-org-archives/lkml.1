Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbYJ0GJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbYJ0GJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYJ0GJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:09:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57237
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYJ0GJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:09:27 -0400
Date: Sun, 26 Oct 2008 23:09:04 -0700 (PDT)
Message-Id: <20081026.230904.103613855.davem@davemloft.net>
To: sergio@larces.uece.br
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] btsdio: free sk_buff with kfree_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <4904194D.1080806@larces.uece.br>
References: <4904194D.1080806@larces.uece.br>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Luis <sergio@larces.uece.br>
Date: Sun, 26 Oct 2008 04:16:29 -0300

> free sk_buff with kfree_skb, instead of kree
>  
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>

Since this is pretty obvious I'm applying this directly, I hope
Marcel doesn't mind :-)
