Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbYH2VWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbYH2VWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYH2VVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:21:50 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:48177 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758802AbYH2VVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:21:50 -0400
Date: Fri, 29 Aug 2008 23:21:46 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080829212146.GA4321@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B80D33.5050806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-08-29 16:52 +0200 schrieb Tejun Heo:

>   http://article.gmane.org/gmane.linux.ide/34077

I have this patch actually applied and had switched off the computer
afterwards completely for more than one hour two times. Each time it
booted then (this was the patch you suggested initially to Many Maxwell
this month to this list).

Everything seems to work fine, but my dmesg and /var/log/messages is
flooded with this now:

Aug 29 23:20:39 zappa ata1: EH complete
Aug 29 23:20:41 zappa ata1: EH complete
Aug 29 23:20:47 zappa ata1: EH complete
Aug 29 23:20:49 zappa ata1: EH complete
Aug 29 23:20:51 zappa ata1: EH complete
Aug 29 23:20:53 zappa ata1: EH complete
Aug 29 23:20:55 zappa ata1: EH complete
Aug 29 23:20:56 zappa ata1: EH complete
Aug 29 23:20:59 zappa ata1: EH complete
Aug 29 23:21:01 zappa ata1: EH complete

I am curious if it boots tomorrow after sleeping for one night :-P

Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
