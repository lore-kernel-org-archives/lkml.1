Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbXFBRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbXFBRN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbXFBRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:13:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36303 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760586AbXFBRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:13:50 -0400
Date: Sat, 2 Jun 2007 10:12:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Kilkenny <akilkenny@xes-inc.com>, wim@iguana.be
Cc: khollis@bitgate.com, linux-standards@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Watchdog API Update
Message-Id: <20070602101202.9d118c44.randy.dunlap@oracle.com>
In-Reply-To: <46606CBA.9020904@xes-inc.com>
References: <46606CBA.9020904@xes-inc.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 14:00:10 -0500 Andrew Kilkenny wrote:

> Patched from 2.6.16
> 
> Included are patches for the Watchdog API. This API is already AD HOC 
> according to the documentation, so the update is not expected to meet 
> much opposition.
> 
> The patch/api update adds support for enabling watchdog monitoring 
> directly via the kernel driver. It appears some drivers do this on their 
> own, while others implement the api, dictating that userspace programs 
> manage the watchdog. This includes adding both the ability for userspace 
> to enable/disable the feature, and to compile in the feature to be 
> enabled automatically at boot.
> 
> The Patch file includes diffs from watchdog.h, the watchdog.txt 
> documentation, and a KConfig file.

what patch file??

> I am unsure on the licensing information. The header file only mentions 
> it was derived from Ken's original code. GPL information is absent, 
> along with dates. In fact, I am unsure where the copyright belongs, if 
> it defaults to Berkshire PC, if it must be GPL, and the like. Guidance 
> will be greatly appreciated, especially if (absent a GPL declaration) I 
> need permission to handle this code.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
