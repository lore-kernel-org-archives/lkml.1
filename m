Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbZAOXak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbZAOXak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbZAOXaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:30:30 -0500
Received: from relay1.sgi.com ([192.48.179.29]:44577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762142AbZAOXa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:30:29 -0500
Message-ID: <496FC713.3040003@sgi.com>
Date: Thu, 15 Jan 2009 15:30:27 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dieter Ries <clip3@gmx.de>
CC: Dieter Ries <clip2@gmx.de>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com> <496FA4B6.3000607@gmx.de> <496FB092.7000400@sgi.com> <496FC08C.4060004@gmx.de>
In-Reply-To: <496FC08C.4060004@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> Mike Travis schrieb:
>> Dieter Ries wrote:
>>> I just tested it. The kernel does boot up, suspending to ram works
>>> perfectly, hibernating did also work, but I found an inconsistent lock
>>> state in dmesg afterwards. System is still fully functional
>>>
>>> May or may not be related, I don't know.
>> If it doesn't happen before my patch, then it's probably related.
>>
> 
> 
> I just tried it without your patches, and the inconsistent lock state
> message is also there after suspending to ram.
> 
> So they dont seem to be related.
> 
> cu
> Dieter

Thanks for the feedback!

Mike

