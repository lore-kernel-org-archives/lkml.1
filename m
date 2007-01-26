Return-Path: <linux-kernel-owner+w=401wt.eu-S1161233AbXAZTp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161233AbXAZTp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXAZTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:45:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:34802 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161233AbXAZTp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=co1V281SOjzIQL0MjdtD/48tjL16b7VKOBTLU5wsvrFP8wmSC6na8p7YAZqTCshSBImt+GpL25X27OLwynulT3OoC/5tmQZv0yuHFHly2W+qU9m+c4uAtjEA/a3G/w59KAySqyhYAGV9QQVvU+FcB0LkxfRPR+1Nv17lICC3+rY=
Message-ID: <45BA5A65.8040500@googlemail.com>
Date: Fri, 26 Jan 2007 20:45:41 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisa³(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz

security/selinux/hooks.c: In function 'selinux_sysctl':
security/selinux/hooks.c:1440: error: 'ctl_table' has no member named 'de'
make[2]: *** [security/selinux/hooks.o] Error 1
make[1]: *** [security/selinux] Error 2
make: *** [security] Error 2

Sysctl patches?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
