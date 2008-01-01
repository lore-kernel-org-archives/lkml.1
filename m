Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYAAVZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYAAVZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYAAVZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:25:09 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3331 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYAAVZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:25:07 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 16:25:07 EST
Date: Tue, 1 Jan 2008 22:17:57 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: G965 & on-board serial port
Message-ID: <20080101211757.GG2340@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Jan  2 20:02:51 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out a problem that I have with 2 different
motherboards. Both have the Intel G965 chipset, an Intel DG965WH and a
Gigabyte 965G-DS3. What happens is, that datacommunication, either
through normal receiving bytes and via fiddling with signalling lines
(for a dcf-77 radio clock) don't work. To be honest I used a vendor
kernel, a Debian 2.6.22-3-amd64 image.
Is this a known problem?


Folkert van Heusden

-- 
MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
view', vs.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
