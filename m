Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZDGU5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZDGU5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZDGU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:57:45 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:53150 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZDGU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:57:44 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DBBE3D.4020303@lwfinger.net>
Date: Tue, 07 Apr 2009 15:57:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP
 nx6325), NFS broken
References: <49DB69FA.1060202@lwfinger.net> <200904072113.20703.rjw@sisk.pl> <49DBA9D0.7080400@lwfinger.net> <200904072249.02211.rjw@sisk.pl>
In-Reply-To: <200904072249.02211.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 07 April 2009, Larry Finger wrote:
>>
>> Do you know anything about a regression that leads to "phy0: Failed to
>> initialize wep: -2" messages? It is the 3rd one that I'm chasing and seems to
>> affect all wireless drivers. For this one, removing and reinserting the driver
>> corrects the problem.
> 
> No, I didn't know about this one.  Has it been reported anywhere already?

Only on the wireless mail list. Once I get the bad commit, I'll post it in LKML.

Larry
