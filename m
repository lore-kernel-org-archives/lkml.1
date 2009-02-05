Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZBEOen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZBEOen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBEOed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:34:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:4623 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZBEOec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:34:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oiczYgp67lL3kpBtLpc+2EqN+5bHCblFIYbNOnoD3vPePkB6iHzZ0giq0/nDoDAAFD
         upsYsZC47cGZ30Fq6dlGDONLN6EJxjb/gBraWwMNvKNZC0fTnR2brrcPeIMVDt8YxA2f
         s5HtD7EjKmSPt0EzV6yJH+Gtza1uu+W/6NJL0=
MIME-Version: 1.0
In-Reply-To: <200902050237.39394.rjw@sisk.pl>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.zq.WwYiJB@chimera>
	 <b6a2187b0902041115u130fcfe7ha1612e2e2fa1ec36@mail.gmail.com>
	 <200902050237.39394.rjw@sisk.pl>
Date: Thu, 5 Feb 2009 22:34:31 +0800
Message-ID: <b6a2187b0902050634r37a4c3ccg55e2d1e22ae2f9c4@mail.gmail.com>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reinette.chatre@intel.com, Sujith.Manoharan@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 9:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 04 February 2009, Jeff Chua wrote:
>> On Wed, Feb 4, 2009 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
>> > Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
>> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
>> > Date            : 2009-01-05 4:13 (31 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4
>>
>> Latest linux git pull seems to behave slightly better. Restarting the
>> interface a few times fixes the problem 70% of the time. The rest of
>> the time, it can't associate with the AP.
>
> Thanks for the update, there is a patch for you to test at
> http://bugzilla.kernel.org/show_bug.cgi?id=12414#c3

Ok, will try that patch next weekend when I get home.

Thanks for the patch.

Jeff.
