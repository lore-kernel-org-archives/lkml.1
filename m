Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZG0Rzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZG0Rzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZG0Rzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:55:49 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:47811 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZG0Rzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dfA97VDEv2P6Tve8qLwDZDmQIr1S+KxJMUuZEynap1FA5cA52EumMA/pp8TYHTDNjc
         n3YIMEILbn6HbRmycr7vUA9RoihrxHV/2sW0SI1oYeyf+hbVPYUNU/rMFGEhhV+Xr1EU
         bc+eu3GBMEeFTFsxUQVUJzBFJHpjTtrjKbCPY=
Message-ID: <4A6DE9D4.406@gmail.com>
Date: Mon, 27 Jul 2009 19:54:28 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13733] 2.6.31-rc2: irq 16: nobody cared
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.ZsD.yHObKB@chimera>
In-Reply-To: <3zAHs5O6maO.A.ZsD.yHObKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2009 10:28 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
> Subject		: 2.6.31-rc2: irq 16: nobody cared
> Submitter	: Niel Lambrechts<niel.lambrechts@gmail.com>
> Date		: 2009-07-06 18:32 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4
>    
Hi,

Bug is still evident on kernels up to 2.6.31-rc4.

Regards,
Niel
