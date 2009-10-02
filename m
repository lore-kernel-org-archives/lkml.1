Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZJBIaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZJBIaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZJBIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:30:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27294 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbZJBIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GE58xU1WxLsRuMg+oHJVFu2jGsjRU1ilvAlJV32Pe2HaghuDB9De06qY6jGS3IWIMx
         qaLKeLSyHThYmQzJIG7Q1RhZPnKWnFf1gAgUhHi9/e2JpdlkxnoSudPLWf2CvjfipZKr
         KfN60f04w5ei8XW/9yluxwiZNlxjwN4LScCwE=
MIME-Version: 1.0
In-Reply-To: <COE24pZSBH.A.7sH.xMTxKB@chimera>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <COE24pZSBH.A.7sH.xMTxKB@chimera>
Date: Fri, 2 Oct 2009 12:30:17 +0400
Message-ID: <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>

Michael has been asked to bisect it (if possible). I cant reproduce it
in kvm unfortunately.

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14270
> Subject		: Cannot boot on a PIII Celeron
> Submitter	: Michael Tokarev <mjt@tls.msk.ru>
> Date		: 2009-09-28 15:26 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=125415160524110&w=4
>
>
>
