Return-Path: <linux-kernel-owner+w=401wt.eu-S965412AbXCTRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412AbXCTRAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCTRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:00:01 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965412AbXCTQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:59:59 -0400
Date: Tue, 20 Mar 2007 09:59:50 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: "Keiichi KII" <k-keiichi@bx.jp.nec.com>, mpm@selenic.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take3 6/6][resend] add ioctls for
 adding/removing target
Message-ID: <20070320095950.72a2ea62@freekitty>
In-Reply-To: <b6fcc0a0703200550p441bb01fkfebb4102ef8e57d@mail.gmail.com>
References: <45FFCF31.3040000@bx.jp.nec.com>
	<45FFD4C1.7000103@bx.jp.nec.com>
	<b6fcc0a0703200550p441bb01fkfebb4102ef8e57d@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since these are network device related ioctl's it might be clearer (and easier)
to use network device (struct ifreq) style ioctl's.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
