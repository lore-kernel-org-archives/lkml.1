Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZLIEav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZLIEav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZLIEas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:30:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44848
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755590AbZLIEar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:30:47 -0500
Date: Tue, 08 Dec 2009 20:30:53 -0800 (PST)
Message-Id: <20091208.203053.170121191.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH] gigaset: don't enable any debugging output by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091205175219.4298A400D9@xenon.ts.pxnet.com>
References: <20091205175219.4298A400D9@xenon.ts.pxnet.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sat,  5 Dec 2009 18:52:19 +0100 (CET)

> When built with debugging support, the Gigaset driver enabled some
> debugging messages by default. Change the default to "all off".
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied.
