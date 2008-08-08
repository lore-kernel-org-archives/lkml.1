Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYHHQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYHHQR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYHHQRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:17:20 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:48066 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbYHHQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:17:19 -0400
Date: Fri, 8 Aug 2008 20:17:17 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Patches to support QE USB Host Controller
Message-ID: <20080808161717.GA19095@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Most patches that were needed to support QE USB Host were merged during
2.6.27 merge window, and only three more patches left over. Here they
are.

David, could you bear with gpio_to_chip() exported function, just as
a stopgap for a proper api?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
