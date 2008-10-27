Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYJ0GKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYJ0GKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYJ0GKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:10:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbYJ0GKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:10:00 -0400
Date: Sun, 26 Oct 2008 23:09:38 -0700 (PDT)
Message-Id: <20081026.230938.205512927.davem@davemloft.net>
To: sergio@larces.uece.br
Cc: dcbw@redhat.com, libertas-dev@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] libertas: free sk_buff with kfree_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <4904195F.1050508@larces.uece.br>
References: <4904195F.1050508@larces.uece.br>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Luis <sergio@larces.uece.br>
Date: Sun, 26 Oct 2008 04:16:47 -0300

> free sk_buff with kfree_skb, instead of kree
>  
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>

Also applied, thanks Sergio.
