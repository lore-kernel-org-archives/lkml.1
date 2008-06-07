Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYFGWyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYFGWyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYFGWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:54:29 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:38931 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYFGWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ScrBkoLqV3tiv3HwKpnsAKLOg0J8pGn31/Bvv8en+RPakZp32vA7a828pgSFs1/03Y
         Kr1tHiKSipMkdRPCGLjLYONV8+xJCZL/9YSCM5f2JYca7PF5+jTsxyIjRmIzjcvkQsHM
         W/cmzPbpNP2ur+SNv9rp8h5yWM3RiUDPg7IwA=
Message-ID: <dd18b0c30806071554t1aa3e1afo34a8ed4d558a6438@mail.gmail.com>
Date: Sat, 7 Jun 2008 22:54:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Oliver Neukum" <oliver@neukum.org>
In-Reply-To: <dCRO4tbfLzK.A.SAD.x2vSIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.SAD.x2vSIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 8:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10825
> Subject         : appletouch after wakeup
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-27 3:29 (12 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
>                  http://lkml.org/lkml/2008/5/31/193
>                  http://lkml.org/lkml/2008/5/31/193
> Handled-By      : Oliver Neukum <oliver@neukum.org>
>
>
>

I'm not seeing appletouch react this way after applying the patches.
regards;

-- 
Justin P. Mattock
