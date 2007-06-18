Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXFRLCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXFRLCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbXFRLCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:02:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760776AbXFRLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:02:35 -0400
Date: Mon, 18 Jun 2007 04:02:53 -0700 (PDT)
Message-Id: <20070618.040253.129088293.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: tgraf@suug.ch, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0EtI-0007Ma-00@dorka.pomaz.szeredi.hu>
References: <E1I0ElR-0007Kz-00@dorka.pomaz.szeredi.hu>
	<20070618.035144.64026005.davem@davemloft.net>
	<E1I0EtI-0007Ma-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 12:55:24 +0200

> I'm all for fixing this gc mess that we have now.  But please don't
> expect me to be the one who's doing it.

Don't worry, I only expect you to make the situation worse :-)
