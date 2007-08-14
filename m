Return-Path: <linux-kernel-owner+w=401wt.eu-S936507AbXHNFNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936507AbXHNFNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbXHNFMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:12:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:45467 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbXHNFMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:12:33 -0400
Message-ID: <46C139BD.1030607@argo.co.il>
Date: Tue, 14 Aug 2007 08:12:29 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: hinoue@ccsl.carleton.ca, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca> <20070814000956.7c8929dd@the-village.bc.nu>
In-Reply-To: <20070814000956.7c8929dd@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 14 Aug 2007 08:12:29 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> This is to protect it from being changed by an attacker or someone trying
> to do strange and bogus things to the kernel.
>   

Someone who apparently hasn't heard of vmap(), etc.

It's a debug aid at best.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

