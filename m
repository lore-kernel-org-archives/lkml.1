Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZHZA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZHZA1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZHZA1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:27:53 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:52087 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZHZA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Oe31ETBvKVVqmS0r5a4S+ROIXXKPpHawAn0BhTW/7pG0tKd1zefJaU7CSfoBYFZXB6
         1bFi8OHIm291hgkemEsm19EL2sQQE6rAuDcavgEiOQXC3t3iBKZ9z3Hxqdvwvfb39Npr
         ggdA2Qv2OdfsW4TYngtqUfxCQIXwxbm4Wafw0=
Message-ID: <4A9481B9.3070607@gmail.com>
Date: Tue, 25 Aug 2009 17:28:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14012] latest git fried my x86_64 imac
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.NXH.BtGlKB@chimera>
In-Reply-To: <_yaHeGjHEzG.A.NXH.BtGlKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14012
> Subject		: latest git fried my x86_64 imac
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-08-13 07:20 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=125014080427090&w=4
>
>
>
>    
if I revert this commit:
af6af30c0fcd77e621638e53ef8b176bca8bd3b4
I can get a normal bootup.

As for this  bug, it seems I'm the only
hitting this. The system is a fresh LFS build
x86_64.
In regards to keeping this open
not sure, I don't have a problem with closing this
and taking the blame as something I did during my build
of the system, then if this becomes more frequent
then open a new bug.

Justin P. Mattock
