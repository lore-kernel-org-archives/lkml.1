Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZKIOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZKIOsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZKIOsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:48:14 -0500
Received: from khc.piap.pl ([195.187.100.11]:57067 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZKIOsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:48:14 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, Daniel Walker <dwalker@fifo99.com>,
       linux-kernel@vger.kernel.org, hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net/compat_ioctl: support SIOCWANDEV
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
	<20091106.204753.223665411.davem@davemloft.net>
	<200911082231.48060.arnd@arndb.de> <200911082239.24698.arnd@arndb.de>
Date: Mon, 09 Nov 2009 15:48:17 +0100
In-Reply-To: <200911082239.24698.arnd@arndb.de> (Arnd Bergmann's message of
	"Sun, 8 Nov 2009 22:39:24 +0100")
Message-ID: <m3eio7g3f2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> This adds compat_ioctl support for SIOCWANDEV, which has
> always been missing.

It looks good, can't test at the moment.
-- 
Krzysztof Halasa
