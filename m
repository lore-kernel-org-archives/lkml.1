Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbZEQDW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbZEQDW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 23:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZEQDWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 23:22:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:33564 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZEQDWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 23:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vkFgSqYC+cpJd7fxBeC0oOJGDDv4xbejK0hoS97cTrhi9Xu52Zsecd8stJQTk6u9Le
         tofdmM/5T7xYgXVOFbxEisTj//Eg7VchCP2t69wVRuB/27cLL0+f/AWnVOriXFWz5Efc
         l9Vk0l+ncHcY+Mpnyo+HvNKIvRNMHSAaESFEQ=
MIME-Version: 1.0
In-Reply-To: <385Pu-agh7M.A.nFB.5YzDKB@chimera>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
	 <385Pu-agh7M.A.nFB.5YzDKB@chimera>
Date: Sun, 17 May 2009 11:22:48 +0800
Message-ID: <d82e647a0905162022k7be627f1s933a84640562f749@mail.gmail.com>
Subject: Re: [Bug #13245] possible circular locking dependency detected
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also can reproduce it on 2.6.30-rc5-next-20090515.

2009/5/17 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13245
> Subject         : possible circular locking dependency detected
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2009-05-04 16:56 (13 days old)
>

-- 
Lei Ming
