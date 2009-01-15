Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbZAOXSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbZAOXSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbZAOXRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:17:54 -0500
Received: from xsmtp1.ethz.ch ([82.130.70.13]:28107 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZAOXRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:53 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 18:17:53 EST
Message-ID: <496FC08C.4060004@gmx.de>
Date: Fri, 16 Jan 2009 00:02:36 +0100
From: Dieter Ries <clip3@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Dieter Ries <clip2@gmx.de>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com> <496FA4B6.3000607@gmx.de> <496FB092.7000400@sgi.com>
In-Reply-To: <496FB092.7000400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2009 23:02:38.0693 (UTC) FILETIME=[5CABB950:01C97765]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis schrieb:
> Dieter Ries wrote:
>> I just tested it. The kernel does boot up, suspending to ram works
>> perfectly, hibernating did also work, but I found an inconsistent lock
>> state in dmesg afterwards. System is still fully functional
>>
>> May or may not be related, I don't know.
> 
> If it doesn't happen before my patch, then it's probably related.
> 


I just tried it without your patches, and the inconsistent lock state
message is also there after suspending to ram.

So they dont seem to be related.

cu
Dieter
