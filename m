Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbXCHMKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbXCHMKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXCHMKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:10:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50887 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbXCHMKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:10:51 -0500
Date: Thu, 8 Mar 2007 13:14:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: kaber@trash.net,
       Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] chaostables
Message-ID: <20070308131412.08d9973e@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 07:35:05 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> Hello netfilter-devel,
> 
> 
> I would like to submit chaostables (v0.5_svn23) for inclusion. Primary 
> use is to detect, spoof and slowdown various sorts of port scans.
> Implementation details can be found at http://jengelh.hopto.org/p/chaostables/


Any chance of tweaking the name - it's just there is/was a chaosnet
protocol/network system and you don't want people to assume that since
its a chaosfilter its for chaosnet  ?
