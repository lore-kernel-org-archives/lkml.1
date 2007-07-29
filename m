Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXG2RMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXG2RMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764245AbXG2RMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:12:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:13944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbXG2RMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qpGEc3pTNfz/HFnHf0/BvHCrzVaE+5ILboDBhm+QKTEA6QJXSN0VMbciRBFX113QpJG1Fbgi8vjNcdovho0hDcxISkTJFI3XyuyJARKqAkZqIck4zEVZZJAPMBcbHgBlzGNwBmv24ENEGzFtgf0p9LPa5n7X9aMbiNvOL6CtJOI=
Message-ID: <46ACC95D.5010702@googlemail.com>
Date: Sun, 29 Jul 2007 19:07:41 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: niklaus.giger@member.fsf.org, linux-kernel@vger.kernel.org,
       linuxppc-embedded@ozlabs.org, kristen.c.accardi@intel.com
Subject: Re: [PATCH] Fix compilation for non CONFIG_HOTPLUG case
References: <200707291807.52042.niklaus.giger@member.fsf.org> <46ACC42E.8040907@ru.mvista.com>
In-Reply-To: <46ACC42E.8040907@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This problem is already fixed in -mm .

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/broken-out/gregkh-driver-kobject-fix-link-error-when-config_hotplug-is-disabled.patch


Regards,

Gabriel
