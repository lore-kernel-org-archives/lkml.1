Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXJGVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXJGVl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXJGVlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:41:22 -0400
Received: from saeurebad.de ([85.214.36.134]:42975 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXJGVlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:41:22 -0400
Date: Sun, 7 Oct 2007 23:41:16 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dtc_setup() used anywhere?
Message-ID: <20071007214116.GA10035@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The compiler warned me that dtc_setup() is unused in drivers/scsi/dtc.c:182.
I do not see a call to it anywhere and no __setup() near to it.  Am I missing
something?

	Hannes

-- 
3BD8 AF56 11AF 205C 9DB6  B10F 76F1 0634 71A4 DCA0
