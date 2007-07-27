Return-Path: <linux-kernel-owner+w=401wt.eu-S937369AbXG0Ok6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937369AbXG0Ok6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935370AbXG0Oj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:39:28 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:35550 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbXG0OjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:39:25 -0400
Subject: Re: [PATCH 4/4] l2cap: don't mangle cmd.len
From: Marcel Holtmann <marcel@holtmann.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <E1IEPNw-0005TA-89@ZenIV.linux.org.uk>
References: <E1IEPNw-0005TA-89@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:41:26 +0200
Message-Id: <1185547286.13228.18.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

> Since nobody uses it after we convert it to host-endian,
> no need to do that at all.  At that point l2cap is endian-clean.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


