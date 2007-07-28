Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXG1QvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXG1QvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXG1QvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:51:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38612 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXG1QvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MkE0hqBh7wxdK6lb5haRRSfmaHxz3CROqScfn6MgB7exZ7VmYdu8fmsOy03JGDsr0XxUyW+7ZX8sIVPsT7YsTGcU3V4iDN7umEOUN8ELkI+YEzwFUwMdBrTqIkANnDlHeif9y0KvCFfLUA63snDTrPO1ASDIxkdmve8FNqF/JiI=
Message-ID: <46AB730A.4050305@googlemail.com>
Date: Sat, 28 Jul 2007 18:47:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: sound/pci/ac97/ac97_patch.h - declared 'static' but never defined
 warnings ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...

sound/pci/ac97/ac97_patch.h:86: warning: 'snd_ac97_restore_status' declared 'static' but never defined
sound/pci/ac97/ac97_patch.h:87: warning: 'snd_ac97_restore_iec958' declared 'static' but never defined

...


Got that with a randconfig ( http://194.231.229.228/MM/randconfig-auto-86.ioat )


Regards,

Gabriel C
