Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZCPQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZCPQsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZCPQrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:47:40 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16257 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbZCPQrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:47:39 -0400
X-BigFish: VPS-30(zz1431J1432R98dR1805M936fKzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <49BE7F4E.2030905@am.sony.com>
Date: Mon, 16 Mar 2009 09:33:18 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de> <49BC5D8C.209@am.sony.com> <20090315085712.GB2865@n2100.arm.linux.org.uk>
In-Reply-To: <20090315085712.GB2865@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 16 Mar 2009 16:33:21.0981 (UTC) FILETIME=[EBC54ED0:01C9A654]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Sat, Mar 14, 2009 at 06:44:44PM -0700, Tim Bird wrote:
>> Uwe Kleine-K�nig wrote:
>>> without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
>>> boot on many maschines.  It would be great if this change would make it
>>> into .29.
>> I'd like to ACK this patch (not sure if my opinion matters).
> 
> You're far too late, the patch has already been committed and the request
> for Linus to pull it has been sent.

OK, great!  I just wanted to add my 2 cents, since I didn't
see any resolution on the mailing list.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

