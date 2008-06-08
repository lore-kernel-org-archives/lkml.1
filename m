Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYFHS1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYFHS1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFHS0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:26:51 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:48153 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYFHS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vz3TTlKXxK+nneLe2rfP7XtlSsdW/YIc0Y7qiOXevjDcnJK6qJqQpGeiO7yQLv2L86
         U6wlh9+TEBACYYlfEPDv7f1FDSlJZ/gaYRV2p8GjLwXILDikwMr7/6NbN149CyDiWj43
         KJ0/uobsAYU/k2lAXyBhcgcmiKuzB3A1Vpk7U=
Message-ID: <dd18b0c30806081126p6a17d321mfcf8b73c6600cc63@mail.gmail.com>
Date: Sun, 8 Jun 2008 18:26:49 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Oliver Neukum" <oliver@neukum.org>
In-Reply-To: <200806081853.50659.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.SAD.x2vSIB@albercik>
	 <dd18b0c30806071554t1aa3e1afo34a8ed4d558a6438@mail.gmail.com>
	 <200806081853.50659.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2008 at 4:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 8 of June 2008, Justin Mattock wrote:
>> On Sat, Jun 7, 2008 at 8:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.25.  Please verify if it still should be listed.
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10825
>> > Subject         : appletouch after wakeup
>> > Submitter       : Justin Mattock <justinmattock@gmail.com>
>> > Date            : 2008-05-27 3:29 (12 days old)
>> > References      : http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
>> >                  http://lkml.org/lkml/2008/5/31/193
>> >                  http://lkml.org/lkml/2008/5/31/193
>> > Handled-By      : Oliver Neukum <oliver@neukum.org>
>> >
>> >
>> >
>>
>> I'm not seeing appletouch react this way after applying the patches.
>
> Still, have the patches reached the Linus' tree yet?
>
> Rafael
>

I'm not sure if they did or not, I think Oliver was working on that,
but am unsure.
regards;

-- 
Justin P. Mattock
