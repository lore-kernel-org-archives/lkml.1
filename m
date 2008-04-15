Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbYDONcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbYDONcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYDONcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:32:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62278 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYDONcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:32:32 -0400
Date: Tue, 15 Apr 2008 16:32:03 +0300
From: Ozgur Yuksel <Ozgur.Yuksel@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: Solved: for_each_netdev() in 2.6.23-gitX / 2.6.24-rc1-gitY breaks Cisco VPN client
Message-ID: <20080415133203.GB9239@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI - I have just did an almost-clean port of Cisco VPN client 4.8 rev 490.
http://www.xceptn.com/patches/vpnclient/vpnclient-4.8-2.6.25-XceptN.patch

Cheers,
Ozgur

-- 

   "...very few phenomena can pull someone out of Deep Hack Mode,
    with two noted exceptions: being struck by lightning, or worse,
    your *computer* being struck by lightning."

                                           -- Matt Welsh

O Z G U R   Y U K S E L | senior principal support engineer | +90 312 4598900
ORACLE Enterprise Linux / OracleVM - Bug Diag & Escalation, KM Lead, EMEA CM
ugur mumcu cad. 88 c-blok 6.kat gop | ankara | TR-06700 | TÜRKiYE
oss.oracle.com | linux.oracle.com | www.oracle.com/virtualization

