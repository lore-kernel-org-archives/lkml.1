Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0CDRF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:05:28 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37784 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756206Ab0CDRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:05:27 -0500
Date: Thu, 4 Mar 2010 20:05:25 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Mark Lord <kernel@teksavvy.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ahci: Add support for non-PCI devices
Message-ID: <20100304170525.GA8126@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks for the feedback on the previous patches!

Here comes v2:

- Patches 1-8 dropped as they are in libata-dev.git;
- Patches 'ahci: Move generic code into libahci' and
  'ahci: Export generic AHCI symbols' were merged into one.
- We no longer touch Kconfig when not needed.
- libahci.h renamed to ahci.h.
- Some cosmetic fixes.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
