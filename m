Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXKAMcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXKAMcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbXKAMcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:32:17 -0400
Received: from userg501.nifty.com ([202.248.238.81]:36093 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbXKAMcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:32:16 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=wQj40xcqRwymIs6EXx4LXwLhsBc4G8f/vCibF7Rnlv8U0YUL/Xw6osxyr1OE5Rsmr
	/lhrnooj9LC9yCtBLBZrw==
X-Nifty-SrcIP: [222.159.205.91]
Date: Thu, 1 Nov 2007 21:30:55 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [bug?  2.6.24-rc1] PATA_PCMCIA:  START_STOP FAILED  after pccardctl
 eject
Message-Id: <20071101213055.5d54a8b2.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The message "START_STOP FAILED" appears
 after I eject pcmcia-ATA card by "pccardctl eject".

Is this correct?

>pccard: card ejected from slot 0
>ata3.00: disabled
>sd 2:0:0:0: [sdb] Stopping disk
>sd 2:0:0:0: [sdb] START_STOP FAILED
>sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK


Best Regards
Komuro

