Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYKURfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYKURfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYKURfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:35:34 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:62167 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYKURfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:35:33 -0500
Message-ID: <4926F15A.4090203@nortel.com>
Date: Fri, 21 Nov 2008 11:35:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: tremolo_72@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: pthread and multiple cores
References: <890000.99085.qm@web65612.mail.ac4.yahoo.com>
In-Reply-To: <890000.99085.qm@web65612.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 17:35:23.0232 (UTC) FILETIME=[884DE600:01C94BFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mak wrote:
> working with a multiple core box, there seems to be core(s) idle and
> not evenly distributed when threads are set(default) with system
> scope. is this a scheduler thing or am i not tuning my pthread
> parameters correctly? thanks.

Your report lacks information required for it to be useful.  Which 
kernel version are you running?  What is your architecture?  How many 
cores do you have, and how many threads?  Are you using cgroups?  If you 
can post your test app that would be even better.

Chris
