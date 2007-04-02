Return-Path: <linux-kernel-owner+w=401wt.eu-S965837AbXDBUbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965837AbXDBUbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965829AbXDBUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:31:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28153 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965823AbXDBUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:31:09 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
X-Message-Flag: Warning: May contain useful information
References: <4611652F.700@zytor.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 02 Apr 2007 13:31:07 -0700
In-Reply-To: <4611652F.700@zytor.com> (H. Peter Anvin's message of "Mon, 02 Apr 2007 13:18:55 -0700")
Message-ID: <adaslbiecxg.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2007 20:31:08.0044 (UTC) FILETIME=[D81044C0:01C77565]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I would therefore like to propose that the Linux Foundation register a
 > PCI ID for use by LANANA ($3000/year), and we set up a LANANA registry
 > for these device IDs, together with a description of the device
 > interface each of them expect.  Similarly, a Subsystem ID registry can
 > be used (for virtualization vendors which don't have their own VID
 > already) to distinguish different implementations.

Sounds like a very good idea.

 > Obviously, anyone who adheres to the published interface can use one
 > of these VID:DIDs -- as far as I'm concerned, even hardware vendors;
 > we'll use the SID to distinguish between implementations.

I think for this to work, some attempt at a conformance testing
program is required...

 - R.
