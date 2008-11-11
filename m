Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYKKMFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYKKMFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYKKMFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:05:43 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:18849 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbYKKMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:05:42 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFABMEGUlR9dQn/2dsb2JhbACBdss6g1c
Date: Tue, 11 Nov 2008 13:05:39 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] drivers/char/nvram.c
Message-ID: <20081111120539.GI2690@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

the next 2 patches update the nvram driver so that:
* it's in line with our coding style guidelines
* and that we convert the PRINT_PROC macro's to the seq_file system.

Please review the patches and sent me comments.
I someone could also test this on an ATARI architecture/platform:
please lett me know if it works.

Thanks in advance,
Wim.

