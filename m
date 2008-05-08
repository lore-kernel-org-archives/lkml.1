Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYEHEGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYEHEGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYEHEG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:06:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYEHEG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:06:26 -0400
Message-ID: <48227C2B.6060201@zytor.com>
Date: Wed, 07 May 2008 21:06:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Daniel Hazelton <dhazelton@enter.net>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl>	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	 <4821A7E2.6080101@keyaccess.nl>	 <200805071539.32594.dhazelton@enter.net>	 <48220BC1.2050701@keyaccess.nl>	 <86802c440805071316p39b7f370u46fa4f36c420bce7@mail.gmail.com> <86802c440805071318u6b9d7f67gaa7d92ae6c3df079@mail.gmail.com>
In-Reply-To: <86802c440805071318u6b9d7f67gaa7d92ae6c3df079@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> may add enable_pat command line, so other guys could test if their
> cpus are ok with PAT...
> 

That would definitely be good.

Also, we should *not* turn on the PAT bit if it was disabled to begin with.

	-hpa

