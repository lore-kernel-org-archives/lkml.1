Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYISJuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYISJuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 05:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYISJuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 05:50:12 -0400
Received: from mail.dgt.com.pl ([94.40.14.70]:48535 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYISJuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 05:50:11 -0400
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <48D375D1.2030606@dgt.com.pl>
Date: Fri, 19 Sep 2008 11:50:09 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: Richard A Nelson <cowboy@cavein.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS root + iptables in 2.6.25
References: <48D3451D.1080807@dgt.com.pl> <alpine.DEB.2.00.0809190057200.14395@hygvzn-guhyr.pnirva.bet>
In-Reply-To: <alpine.DEB.2.00.0809190057200.14395@hygvzn-guhyr.pnirva.bet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> NFS and iptables definitely takes some care - and there are still holes
> - no way to specify ports for all requests...
>
> but this seems odd...  you must've had some extant rules that suddenly
> seemingly changed behaviour before the modprobe was done
>
>
it was first module loaded
