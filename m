Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYISPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYISPe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYISPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:34:20 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:60951 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYISPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:34:19 -0400
Message-ID: <48D3C67B.70909@yahoo.com>
Date: Fri, 19 Sep 2008 16:34:19 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: rankincj@yahoo.com
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Thinkpad T60p does not recover from Suspend when docked.
References: <fa.C7YhwtyrMiD4q9ieD9AI3xtKz1U@ifi.uio.no>
In-Reply-To: <fa.C7YhwtyrMiD4q9ieD9AI3xtKz1U@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 274e18b0ab964d7bff6fd291ad3e0b2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rankin wrote:
> My user-space environment is Fedora 9, which automatically mounts the
> docking station's drive under /media when I login. However, it
> doesn't make any difference if I unmount this drive before suspending
> - the laptop fails to recover regardless.
> 
> I am running a 2.6.25.17-SMP kernel (for graphics card reasons), and

If you are using binary only graphics card drivers does the problem also 
happen without them never loaded at all?

I had a machine that would not suspend properly until some time part way 
through the 2.6.25 kernel. It might be worth reporting whether you have 
the same problem (perhaps by using a live cd) when you use a 2.6.26 or 
later kernel...
