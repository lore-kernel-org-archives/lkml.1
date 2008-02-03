Return-Path: <linux-kernel-owner+w=401wt.eu-S936439AbYBCJpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936439AbYBCJpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbYBCJoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:44:55 -0500
Received: from defg501.nifty.com ([202.248.238.128]:32667 "EHLO
	defg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbYBCJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:44:54 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 04:44:53 EST
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=lrDdy241dayIxvVlAvDmm6gjbMY/XbUMLaq4M+o0Su31nFK5GqAsANb73gHJJ9i28
	OuaRVYzkk9OXW3ZEvaG3g==
X-Nifty-SrcIP: [222.159.205.62]
Date: Sun, 3 Feb 2008 18:30:19 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [BUG?  2.6.24] PATA_PCMCIA:  START_STOP FAILED  after pccardctl
 eject
Message-Id: <20080203183019.4637b043.komurojun-mbn@nifty.com>
In-Reply-To: <20071101213055.5d54a8b2.komurojun-mbn@nifty.com>
References: <20071101213055.5d54a8b2.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Alan
 
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

