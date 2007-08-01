Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXHAKds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXHAKds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXHAKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:33:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:5106 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXHAKdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=X7kp2T2m3I/JkSfvuMcivd9H11TTq3fqzte3HM0nKggcDuTrn3ZH3wyZUOT0PepFvvVbNc6bkdVy9jH6q2DCO5JetH0KHBSqsvk+UYo2Lpb0KCk+iyXqrTP6UJZhkW7Pc30ROhyTzZPupheLKr2sGuJJdfV3uD9ku0PwuNRcFww=
Message-ID: <46B0616E.5000704@googlemail.com>
Date: Wed, 01 Aug 2007 12:33:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
Subject: unionfs compile error ( Re: 2.6.23-rc1-mm2 )
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

....

fs/unionfs/file.c:147: error: 'file_fsync' undeclared here (not in a function)
make[2]: *** [fs/unionfs/file.o] Error 1
make[1]: *** [fs/unionfs] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....

...

Config can be found there -> http://194.231.229.228/MM/config-auto-3


Regards,

Gabriel
