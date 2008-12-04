Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYLDRCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYLDRCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLDRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:01:57 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3248 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYLDRB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:01:56 -0500
Date: Thu, 4 Dec 2008 18:01:53 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.27] filesystem (ext3) corruption (access beyond end)
Message-ID: <20081204170153.GJ1547@vanheusden.com>
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
Reply-By: Fri Dec  5 10:48:25 CET 2008
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.26 and 2.6.27 a system of mine (a P4 with HT and IDE disk) gets
massive disk-corruption: in dmesg warnings for access beyond drive end.
Now this bug did not happen in 2.6.18 (debian kernel) and it seems to
be gone in 2.6.28-rc* as well.
My question now is: should it still be investigated?


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
