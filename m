Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZLCUuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZLCUuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZLCUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:50:17 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:64154 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZLCUuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:50:14 -0500
Date: Thu, 03 Dec 2009 21:49:59 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] remove compiling warning by adding uninitialized_var()
To: Coly Li <coly.li@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <4B180462.4050904@suse.de>
In-Reply-To: <4B180462.4050904@suse.de> (from coly.li@suse.de on Thu Dec  3
	19:25:20 2009)
X-Mailer: Balsa 2.3.21
Message-Id: <1259873399l.8450l.1l@oscar.alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-12-03 19:25:20, Coly Li wrote:
> This patch removes some "may be used uninitialized" compiling  
> warnings by adding uninitialized_var(), while the
> uninitialized variables are initialized properly.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Bob Copeland <me@bobcopeland.com>
> Cc: Anders Larsen <al@alarsen.net>

wrt fs/qnx4:
Acked-by: Anders Larsen <al@alarsen.net>
