Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbZBECoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbZBECoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbZBECoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:44:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37085 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbZBECoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dfkjpjVpdbLvrjUMeeRJl3TIlgblM1T5SIR2KoczzM478wjJNyZPtsCMtDuLFbVKf2
         NFCwsBfh23H6aqAcTLXyD7LnCCw4/GAz5odzbqeYlkYhQjwGcNKOuRwEQJjJTzrOe3ex
         EZGvyjhRF5p0LT9mEWI7F25aELRhI0/EP3Ijw=
MIME-Version: 1.0
In-Reply-To: <CGyEB0S4BpO.A.C8C.-5YiJB@chimera>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
	 <CGyEB0S4BpO.A.C8C.-5YiJB@chimera>
Date: Thu, 5 Feb 2009 03:44:03 +0100
X-Google-Sender-Auth: 6843508e1cf6834d
Message-ID: <a5d587fb0902041844v40f1d441s535d070437aa9823@mail.gmail.com>
Subject: Re: [Bug #12393] debugging in dosemu causes lots of 'scheduling while 
	atomic'
From: Michal Suchanek <hramrach@centrum.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said earlier I have received a patch that I applied locally and
that fixes the problem.

As to if and when the patch actually appears in the kernel is out of
my control, and nobody told me that it was applied.

If you believe it was applied to a kernel version that is readily
available for download I am wiling to test such version.

Thanks

Michal

2009/2/4 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12393
> Subject         : debugging in dosemu causes lots of 'scheduling while atomic'
> Submitter       : Michal Suchanek <hramrach@centrum.cz>
> Date            : 2009-01-09 07:28 (27 days old)
>
>
>
