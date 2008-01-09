Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYAIPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYAIPcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAIPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:32:45 -0500
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1800 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYAIPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:32:44 -0500
Date: Wed, 9 Jan 2008 16:32:42 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Cc: udovdh@xs4all.nl
Subject: [RS232] setting trigger-level of fifo
Message-ID: <20080109153242.GU8331@vanheusden.com>
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
Reply-By: Thu Jan 10 13:04:15 CET 2008
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In windows one can configure at what point the uart will trigger an
interrupt. E.g. 1, 4, 8 or 14 bytes received. Setserial doesn't let you
and I saw in the sources of the serial driver no hint that it is
supported in linux at all. Also in MAINTAINERS I saw that sreial is
orphaned. Can someone tell how I can proceed with this? Is it at all
possible to do this setting? 


Folkert van Heusden

-- 
Multi tail barnamaj mowahib li mora9abat attasjilat wa nataij awamir
al 7asoub. damj, talwin, mora9abat attarchi7 wa ila akhirih.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
