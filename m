Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbZGYKev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbZGYKev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 06:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZGYKev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 06:34:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:53689 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZGYKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 06:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=bxzTT0bND/oD5MRGxnQf1nDiLDAKafo7xYJxXz0k+aZEr8rRstzYltb1iwWs5pl2Iz
         JB4Y/btMAgQECb0dmBTHYGvMJTIosPOyWx3CYm628DPwmrjrdpQwEhBTEeoYXfaMlnIv
         R7L+dGbMa3qUBVrk1u24QvrYqqIrw725ir5b0=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Xric Piel <eric.piel@tremplin-utc.net>, webmaster@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: Linux 2.6.27.28
Date: Sat, 25 Jul 2009 20:34:40 +1000
Organization: scattered
Message-ID: <npnl65h39pn5gsv1d81kndleo9qpn05els@4ax.com>
References: <20090724222746.GA30562@kroah.com> <4A6A48A1.80608@tremplin-utc.net> <20090725033030.GA481@suse.de> <ck4l6511epc17ngfdu7qu8ln46b7op9lj9@4ax.com> <20090725052616.GA20432@suse.de>
In-Reply-To: <20090725052616.GA20432@suse.de>
X-Mailer: Forte Agent 5.00/32.1171
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 22:26:16 -0700, you wrote:

>On Sat, Jul 25, 2009 at 03:06:37PM +1000, Grant Coady wrote:
>> On Fri, 24 Jul 2009 20:30:30 -0700, you wrote:
>> 
>> >How many people really are relying on this .27 branch, becides the
>> >distros, these days?  And if you are, why?
>> 
>> I'm using it on the firewall box because iptables is broken in later 
>> kernels :(
>
>Is this something that you have reported to the proper people to get
>fixed?  Or is a known issue?

Been reported -- no fix, and now there's a new userspace (yet again) to 
confuse issues.  At least 2.6.27.x works.

Grant.
-- 
http://bugsplatter.id.au
