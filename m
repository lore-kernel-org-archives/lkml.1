Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZGDVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZGDVY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZGDVYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 17:24:50 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:58134 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbZGDVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 17:24:50 -0400
From: Frans Pop <elendil@planet.nl>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Subject: Re: Core i7 not scaling frequency down
Date: Sat, 4 Jul 2009 23:24:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090704203732.GA20170@codeblau.de>
In-reply-To: <20090704203732.GA20170@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907042324.51551.elendil@planet.nl>
X-OriginalArrivalTime: 04 Jul 2009 21:24:52.0807 (UTC) FILETIME=[DE8E0D70:01C9FCED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner wrote:
> Any ideas what I could do now to get the CPU to slow down?

What cpu frequency governor are you using?

Take a look in /sys/devices/system/cpu/cpu0/cpufreq/. I'd suggest ensuring 
you're using the "ondemand" governor as a first step in managing CPU 
speed.

Cheers,
FJP
