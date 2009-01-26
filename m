Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZAZRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZAZRCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZAZRBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:01:40 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3809 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZAZRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:01:37 -0500
Date: Mon, 26 Jan 2009 18:01:30 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29rc1 brakes usb
Message-ID: <20090126170130.GG6158@vanheusden.com>
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
Reply-By: Sat Jan 24 21:33:23 CET 2009
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since version 2.6.29rc1 querying cleware USb devices no longer works.
2.6.28 works fine. 2.6.29-rc2 also no longer works.

I googled for git bisect but it seems that will take a looong time
(building kernel takes aprox 4 hours) so maybe there's a shortcut I can
take?


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
