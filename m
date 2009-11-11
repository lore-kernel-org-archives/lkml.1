Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZKKRIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZKKRIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZKKRIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:08:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42627 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZKKRIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:08:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lbhfWTrYoKr0BYOgLQwFO41WrgJljSDzUDH7jd2Xtjfabw+OR3DVgEHVElmgPI5hAV
         wcZcDc8sPvL1Tdlc6kOx8b68R9yP/SbDuwYOjPYwyUzYg1y+g2hz7owSGysPENKSqxgg
         xb3uPjJglRQnCdVIXIVtUQ3Ghj/qXa0qLIRGM=
Message-ID: <4AFAEF78.4080807@gmail.com>
Date: Wed, 11 Nov 2009 12:08:08 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH resent] Documentation: rw_lock lessons learned
References: <4AF9C540.5090403@gmail.com> <20091110180646.2e5859a8@nehalam>
In-Reply-To: <20091110180646.2e5859a8@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> I would rather see the text in Documentation/spinlocks give an explaination
> as to why reader/writer locks are normally not desirable. 
> 
> The whole document needs work to make it a developer document, rather than
> a historical mail thread..  A good document says what should be done today,
> and does not have old junk or ask the reader to overly new context
> on old information.
> 
You wish me to merge our patches?

Or this is a second patch in a proposed series?
