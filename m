Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbXEQAzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbXEQAzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXEQAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:55:32 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:59222 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEQAzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:55:31 -0400
Message-ID: <464BA7C2.5040504@gentoo.org>
Date: Wed, 16 May 2007 20:54:26 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
CC: davej@redhat.com, duaneg@dghda.com, prakash@punnoor.de,
       linux-kernel@vger.kernel.org, Ed Sweetman <safemode2@comcast.net>
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <20070517002614.GU15763@ifa.hawaii.edu>
In-Reply-To: <20070517002614.GU15763@ifa.hawaii.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Hoblitt wrote:
> I don't think this is quiet right either as Ed Sweetman has reported
> that this issue doesn't occur on single socket/multi-core systems.

Where did he write that? In an off-list mail, Ed seemed to agree with my 
patch.

Daniel

