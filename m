Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbXHXVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbXHXVEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXHXVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:04:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXHXVEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:04:23 -0400
Message-ID: <46CF468E.1080607@ncsu.edu>
Date: Fri, 24 Aug 2007 16:58:54 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB Key light on/off state depending on mount
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most USB keys nowadays have a small LED somewhere inside of them that 
lights up when they are plugged in. On a windows box, the key is lit up 
whenever it is mounted, and as soon as it is unmounted it turns off, 
giving a handy physical indicator that the key is safe to remove. On 
linux, the light is simply on whenever the key is plugged in.

Should linux toggle the light depending on mount state? Is it as trivial 
as it seems or does this reflect some larger issue?

-Casey Dahlin
