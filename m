Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbZE2Tsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbZE2Tsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZE2Tse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:48:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZE2Tsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:48:33 -0400
Message-ID: <4A203BFD.7040000@kernel.org>
Date: Fri, 29 May 2009 12:48:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
References: <1243625720.4426.0.camel@plop>
In-Reply-To: <1243625720.4426.0.camel@plop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> (Resending because of wrong To:, sorry for the duplicate)
> 
> We have a machine here where hard disk is no longer detected at boot
> time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
> not on the same one with HIGHMEM64G). 
> 
> Motherboard is ECS PF22 Extreme
> 
> bisect blames this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
> 

boot log with debug please.

YH
