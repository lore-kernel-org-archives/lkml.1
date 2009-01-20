Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZATJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZATJt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZATJtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:49:47 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:61846 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZATJtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:49:46 -0500
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 04:49:46 EST
Date: Tue, 20 Jan 2009 10:27:07 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 14/20] fs/qnx4: return f_fsid for statfs(2)
To: Coly Li <coly.li@suse.de>
Cc: linux-kernel@vger.kernel.org
References: <4974B9DC.9060305@suse.de>
In-Reply-To: <4974B9DC.9060305@suse.de> (from coly.li@suse.de on Mon Jan 19
	18:29:16 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1232443627l.1106l.0l@ecxwww1.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-19 18:29:16, Coly Li wrote:
> This patch makes qnx4 file system return f_fsid info for statfs(2).
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Anders Larsen <al@alarsen.net>

Acked-by: Anders Larsen <al@alarsen.net>

