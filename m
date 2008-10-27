Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYJ0Hh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYJ0Hh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYJ0Hhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:37:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35866 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYJ0Hhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:37:39 -0400
Subject: Re: [patch 1/2] btsdio: free sk_buff with kfree_skb
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: sergio@larces.uece.br, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081026.230904.103613855.davem@davemloft.net>
References: <4904194D.1080806@larces.uece.br>
	 <20081026.230904.103613855.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 09:37:42 +0100
Message-Id: <1225096662.7157.7.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > free sk_buff with kfree_skb, instead of kree
> >  
> > Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> 
> Since this is pretty obvious I'm applying this directly, I hope
> Marcel doesn't mind :-)

that is fine with me. No need to run this through me.

Regards

Marcel


