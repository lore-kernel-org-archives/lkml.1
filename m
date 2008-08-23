Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYHWT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYHWT7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYHWTrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:47:43 -0400
Received: from web82102.mail.mud.yahoo.com ([209.191.84.215]:41615 "HELO
	web82102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756991AbYHWTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:47:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=3cqg3fDvRfVprvLSlT0prxujUVTs8FW1XlisUmqVf7mDTF6Fw2iYLjoXO4SjXh4QL/df5DPM0dU0JE0eX/CWYb4R0xEba6YrJR36DGmQTQ7KG8S+WZkwkXej/gPwvBasyoGwaycBQ7NGCvfsZfs/wNPNpDnQIwHo+WWpKnXPPYA=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sat, 23 Aug 2008 12:47:41 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kenrel@gmail.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <772766.85250.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> please check v2.

Thanks Yinghai.  This still applies to a different line number in
v2.6.27-rc4 than what the patch indicates.  I also get a warning
about unused variable "i" (I commented it out in my previous fix,
but not this time).

At any rate, I still produces a kernel that hangs at the typical
location.


Dave W.
