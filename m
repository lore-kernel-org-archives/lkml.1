Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXJHJnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXJHJnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 05:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXJHJnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 05:43:00 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:38717 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbXJHJm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 05:42:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org
Subject: compilation warning with rc9
Date: Mon, 8 Oct 2007 11:44:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710081144.30874.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting this warning compiling rc9:

  CC [M]  drivers/isdn/i4l/isdn_common.o
drivers/isdn/i4l/isdn_common.c: In function ‘isdn_write’:
drivers/isdn/i4l/isdn_common.c:990: warning: array subscript is above array bounds
drivers/isdn/i4l/isdn_common.c: In function ‘isdn_read’:
drivers/isdn/i4l/isdn_common.c:990: warning: array subscript is above array bounds

	Regards
		Oliver
