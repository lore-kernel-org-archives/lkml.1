Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752630AbYLREU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYLREU3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 23:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYLREUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 23:20:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60617 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYLREUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 23:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gs1m774WTyKpM5MHIuoe0f6x/a4mDsZw8BfLzrs62PO5ZcXsi6lYFdLhxCiWU51hI2
         okdB89TYR841rLWRhuMEsCRp/ukhsmJte/CDJWUL739vMyKYXddn16Uhhb44ZT+T0MbJ
         6Xp0zxL3BfTFuWUPSmCDEemTwTMhzkZNdAVVk=
Message-ID: <aa79d98a0812172020q2f541f82g8e0bfe973d12217f@mail.gmail.com>
Date: Thu, 18 Dec 2008 07:20:07 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ppp_generic - use idr technique instead of cardmaps
Cc: akpm@linux-foundation.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, xemul@openvz.org
In-Reply-To: <20081217.174102.121955000.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216192000.GF26390@localhost>
	 <20081217171625.776d4e46.akpm@linux-foundation.org>
	 <20081217.174102.121955000.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll fix the snippets pointed by Andrew within 12 hours (can't make it
right now), thanks!
