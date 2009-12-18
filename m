Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZLRPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZLRPwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZLRPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:52:49 -0500
Received: from bitwagon.com ([74.82.39.175]:59958 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753030AbZLRPws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:52:48 -0500
Message-ID: <4B2BA543.6070302@bitwagon.com>
Date: Fri, 18 Dec 2009 07:52:35 -0800
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracing: gcc for x86 calling mcount with -fomit-frame-pointer
References: <4B2A689D.2050202@bitwagon.com> <87vdg5s9tw.fsf@basil.nowhere.org>
In-Reply-To: <87vdg5s9tw.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 11:02 AM, Andi Kleen wrote:
> John Reiser<jreiser@bitwagon.com>  writes:
>
>> On x86 and x86_64, current "gcc -pg -fomit-frame-pointer" is not allowed.
>> This experimental patch against:
>>    http://mirrors.kernel.org/fedora/releases/12/Fedora/source/SRPMS/gcc-4.4.2-7.fc12.src.rpm

> I submitted a similar patch for all of this some time [ago] to gcc,
> and also resubmitted it recently.  ...  they told me it's queued in some way
 > for the next stage 1.  ...

> I also have a glibc patch for this.

I found  http://gcc.gnu.org/ml/gcc/2009-11/msg00565.html .
Where is the glibc patch?  Reports by users of successful experiences
can help shorten the cycle for official changes.

-- 
