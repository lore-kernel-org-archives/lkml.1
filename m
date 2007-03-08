Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXCHRKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXCHRKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXCHRKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:10:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35017 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbXCHRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:10:07 -0500
Date: Thu, 8 Mar 2007 18:14:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: James Morris <jmorris@namei.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       kaber@trash.net
Subject: Re: [PATCH] chaostables
Message-ID: <20070308181401.1b58ba24@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
	<20070308131412.08d9973e@lxorguk.ukuu.org.uk>
	<Line.LNX.4.64.0703080955060.8029@d.namei>
	<Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Also note that the word 'chaostables' does not even appear in the patch, 
> though xt_CHAOS does. Since we know that {xt,ipt}_[A-Z]+ are targets, we 
> can safely assume that CHAOS does what it says - make fun of nmap.

"entropy" ?
"randomness"

