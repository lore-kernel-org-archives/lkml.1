Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbXFRH5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbXFRH5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXFRH4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:56:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49303
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbXFRH4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:56:53 -0400
Date: Mon, 18 Jun 2007 00:57:11 -0700 (PDT)
Message-Id: <20070618.005711.21897961.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu>
References: <20070607.184731.10907840.davem@davemloft.net>
	<E1HxgeN-0006Io-00@dorka.pomaz.szeredi.hu>
	<E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 09:49:32 +0200

> Ping Dave,
> 
> Since there doesn't seem to be any new ideas forthcoming, can we
> please decide on either one of my two sumbitted patches?

You just need to be patient, we can't just put a bad patch
in because a better one has not been suggested yet :-)
