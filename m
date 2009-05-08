Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZEHLRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZEHLRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763406AbZEHLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:17:26 -0400
Received: from mailrelay.tu-graz.ac.at ([129.27.2.202]:62091 "EHLO
	mailrelay.tugraz.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763351AbZEHLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:17:23 -0400
X-Greylist: delayed 2977 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 07:17:23 EDT
X-DKIM: Sendmail DKIM Filter v2.7.2 mailrelay1.tugraz.at n48ARiHN013850
To: linux-kernel@vger.kernel.org
Subject: Asus Eee 901Go ACPI errors on 2.6.30-rc4-git4
From: Mario Lang <mlang@tugraz.at>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
Date: Fri, 08 May 2009 12:27:18 +0200
Message-ID: <87vdobq48p.fsf@fzidpc73.tu-graz.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TUG-Backscatter-control: UN0hWdfVVWxETLqs7cDVLw
X-Spam-Scanner: SpamAssassin 3.002005 
X-Spam-Score-relay: 0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Booting 2.6.30-rc4-git4 on an Asus Eee 901Go I get the following in dmesg:

[   27.005071] ACPI: EC: missing confirmations, switch off interrupt mode.
[   27.548097] ACPI Exception (evregion-0422): AE_TIME, Returned by Handler for [EmbeddedControl] [20090320]
[   27.548139] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST1] (Node f7033d4c), AE_TIME
[   27.548280] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70366f8), AE_TIME
[   27.548393] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7034c48), AE_TIME
[   27.548521] ACPI Exception (battery-0385): AE_TIME, Evaluating _BST [20090320]

-- 
Regards,
      Mario Lang

Graz University of Technology        mailto:mlang@TUGraz.at
Department Computing               http://www.ZID.TUGraz.at/lang/
Phone: +43 (0) 316 / 873 - 6897
