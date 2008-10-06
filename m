Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYJFVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYJFVXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYJFVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:23:12 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:47107 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753216AbYJFVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:23:11 -0400
Date: Mon, 6 Oct 2008 23:23:07 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081006212307.GA881@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006211906.GA31148@anita.doom>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I forgot is, that the 

ata2: EH pending after 5 tries, giving up
ata2: EH complete
ata2: EH pending after 5 tries, giving up
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete

is away now and tomorrow morning I will take care if it 
manages to do a cold boot after it was switched of this night.

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
