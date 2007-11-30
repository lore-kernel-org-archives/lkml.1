Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXK3Kkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXK3Kkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761123AbXK3KkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:40:22 -0500
Received: from main.gmane.org ([80.91.229.2]:50999 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbXK3KkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:40:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice regression?
Date: Fri, 30 Nov 2007 11:39:59 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2007.11.30.10.39.59.123375@wizards.de>
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Btw, the r8169 has NAPI enabled.

kernel config:
http://hoho.dyndns.org/~holger/dist/kernel-config-x86-2.6.23.9

dmesg:
http://hoho.dyndns.org/~holger/dist/dmesg

lspci -vv:
http://hoho.dyndns.org/~holger/dist/lspci

thanks
Holger


