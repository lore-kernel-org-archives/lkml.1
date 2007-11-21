Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbXKUUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbXKUUhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXKUUhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:37:43 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2360 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbXKUUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:37:42 -0500
Date: Wed, 21 Nov 2007 21:37:36 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: spreading the heat?
Message-ID: <20071121203736.GG30153@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sat Nov 17 09:54:11 CET 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering: if a quad core runs 2 processes at max cpu usage, won't
that wear out the chip? As the heat is not egally spread out, some parts
will expand more then other parts, may give damage won't it?
So what I was suggesting maybe if that is the situation for longer time,
maybe such processes should be scheduled to other cores as well?


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
