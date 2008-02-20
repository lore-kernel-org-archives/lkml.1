Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYBTQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYBTQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbYBTQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:58:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55485 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844AbYBTQ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:58:51 -0500
Message-ID: <47BC5C48.2040509@garzik.org>
Date: Wed, 20 Feb 2008 11:58:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>
Subject: XFS makefile-2.6 lives on
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current upstream, fs/xfs/Makefile-linux-2.6 is zero bytes, which 
means 'make distclean' deletes, and git promptly (and properly) squawks 
about a working tree/index difference.

Would somebody please delete this file?

Thanks,

	Jeff


