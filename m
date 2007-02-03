Return-Path: <linux-kernel-owner+w=401wt.eu-S1945951AbXBCMZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951AbXBCMZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 07:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945963AbXBCMZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 07:25:07 -0500
Received: from main.gmane.org ([80.91.229.2]:34098 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951AbXBCMZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 07:25:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: lnx.tmp@gmail.com
Subject: Re: Slower CPU frequency reported by the kernel
Date: Sat, 3 Feb 2007 12:19:43 +0000 (UTC)
Message-ID: <eq1ukv$p21$1@sea.gmane.org>
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cs78145192.pp.htv.fi
User-Agent: pan 0.120 (Plate of Shrimp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 12:11:25 +0100, Francis Moreau wrote:
> Hi,
> 
> I'm using a PC with AMD 64 3000+ cpu which is theoricaly running at
> 2Ghz. But when looking at /proc/cpuinfo, the kernel reports that it
> runs only at 1Ghz:
> ...
> What's going wrong ?

Do you have feature called "Cool N' Quiet" enabled in BIOS?
I had the same problem and disabling the feature the problem resolved.

