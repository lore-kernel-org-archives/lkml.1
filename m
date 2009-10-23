Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZJWSPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZJWSPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZJWSPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:15:12 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:58997 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZJWSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:15:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj4FAPqP4UpXQJ6o/2dsb2JhbACBUIEwkGbGCYQ/BA
Message-ID: <4AE1F29B.1090009@computer.org>
Date: Fri, 23 Oct 2009 20:14:51 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@linux.intel.com>, Greg KH <greg@kroah.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: pata sc1200 fix crash boot, bug #14227
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little while ago [1], a fix was posted here for a boot-time crash in the sc1200 module.

[1]: http://marc.info/?l=linux-kernel&m=125484259025909&w=2

Submission to stable was also briefly discussed, but has apparently not happened, despite the fact that this bug appears to have existed since 2.6.29.

I would therefore like to request that this fix now be submitted to stable.

Thank you.

Jan
