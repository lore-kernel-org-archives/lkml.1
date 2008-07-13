Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYGMTfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYGMTfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYGMTev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:34:51 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:39645 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYGMTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hZt+dxPI69PS2OMLrBWXys5W4Oc9HMcL0pyXTRkqqQC6ywlr0F9gQOuh2WjMBZSfgM
         CFNTwzAo0Y1YRVhkXv1Trn354Ybtc4UD0/PGa3bKBA0kzLPhaLB658I+J7ydNpUS/oaM
         PG7AKqurCoauR4C70dPLhF486wUDFLzEHjvj4=
Message-ID: <dd18b0c30807131234n5edf3e1dt93022a45d427b1fd@mail.gmail.com>
Date: Sun, 13 Jul 2008 19:34:48 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <c6ZRbn0adb.A.LgB.aKleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 6:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (59 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>
>
>

Yeah I think it would be a good idea to still have this as a bug.

-- 
Justin P. Mattock
