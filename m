Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbXHaIhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbXHaIhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXHaIh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:37:28 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:59812 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXHaIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:37:27 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: possible build system oddity
Date: Fri, 31 Aug 2007 10:37:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311037.29280.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I only touched sound/usb/usbaudio.c
Nevertheless the whole subtree und sound/ is recompiling. What's
happening?

	Regards
		Oliver
