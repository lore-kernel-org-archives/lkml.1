Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642Ab0CLVZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:25:22 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:32804 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934626Ab0CLVZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Osd7aAWZjHLBdtLcvOmQw3KQizAisWrxpGz5F4DSIjxL5Iboghsn0CfC9L8bM1IIYp
         NWn+waXDMAchhOItCCSmiw/jPoETNAdpnl2Pq3zO0wO10fmP0sQoJi62mK7XxUwxwkw7
         +FdL7ddWfXKSazU4XTJ/frnKdYIlkFgZwGJnI=
MIME-Version: 1.0
In-Reply-To: <201003042012.36416.rjw@sisk.pl>
References: <201003040125.30091.rjw@sisk.pl>
	 <b170af451003040311g3cea44caj1cd0e23e55814696@mail.gmail.com>
	 <201003042012.36416.rjw@sisk.pl>
Date: Fri, 12 Mar 2010 22:25:17 +0100
Message-ID: <b170af451003121325h388ba4e5rcb73d1929ffedd1d@mail.gmail.com>
Subject: Re: [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 4 marca 2010 20:12 użytkownik Rafael J. Wysocki <rjw@sisk.pl> napisał:
>> Can we send this to stable for .32 and .33?
>
> That depends on Len.

Len?

-- 
Rafał
