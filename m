Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbXGFUwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbXGFUwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXGFUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:52:23 -0400
Received: from main.gmane.org ([80.91.229.2]:53253 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbXGFUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:52:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [RFC][PATCH] introduce panic_gently
Date: Fri, 6 Jul 2007 20:52:09 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf8tbkd.bju.olecom@flower.upol.cz>
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz> <468DF5D9.4040803@anagramm.de> <p73hcoh20zq.fsf@bingen.suse.de>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (06 Jul 2007 14:03:05 +0200)

>> The 180seconds reboot timeout also doesn't make sense here. The problem
>> won't go away after a reboot without user interaction.
>
> It will when lilo -R/grubonce were used or the NFS server fixed itself
> on nfs root or ... There can be many reasons for it being a good idea.

Hope Peter with his 16bit C rewrite will implement this in early boot
code, thing that i was crying about.
____


