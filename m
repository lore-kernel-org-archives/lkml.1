Return-Path: <linux-kernel-owner+w=401wt.eu-S1765928AbZFLNfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765928AbZFLNfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765050AbZFLN1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:27:53 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:64621 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765055AbZFLN1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AVW9j6Ke/DlNSt47pukpdWYvHy0RKMqKxJKjnfNSOrS+1jamU2RBYO635foPI49WUE
         XKxZlQ5JfhjB72UbtTiLKQcKtDCpGSsXbt1XkqwId+MWaH7+tNvFWvSoVi4Z2dMzuB8v
         V+a9ug3K9Z2j8ZHE4OFADM7RTNo9QDIhMSsaQ=
MIME-Version: 1.0
In-Reply-To: <38b2ab8a0906080029n5d0e167oc2fc217f19882816@mail.gmail.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.LpH.8Z7KKB@chimera>
	 <38b2ab8a0906080029n5d0e167oc2fc217f19882816@mail.gmail.com>
Date: Fri, 12 Jun 2009 15:27:51 +0200
Message-ID: <38b2ab8a0906120627l51f8fcbby934e3459ce148d26@mail.gmail.com>
Subject: Re: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Francis Moreau <francis.moro@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 9:29 AM, Francis Moreau<francis.moro@gmail.com> wrote:
> Hello
>
> On Sun, Jun 7, 2009 at 11:52 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>
> I just pulled the 2.6.30-rc8 kernel.
>
> I'm giving it a test during this week and let you know if the bug
> comes up again.
>

It's still there on 2.6.30-rc8

-- 
Francis
