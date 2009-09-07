Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZIGDZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZIGDZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbZIGDZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:25:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:52785 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbZIGDZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yDhnFYFQrE9nkNQYPexZEznq2RO5s/pU2FM/cLXJTJ3cVaL7EbFHPOtTriWK1VVkOp
         BhEOJz6rMiOVvquEFKzZiTdQO8Out4V/46lqC2PE7zRdqFoc93uoF9guOdCpxuHRG1pC
         EcYfuzx/Tc0ICOWX59Q5of1QezfHYCoCyk8IQ=
Message-ID: <4AA47DF8.80302@gmail.com>
Date: Mon, 07 Sep 2009 00:28:56 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13836] suspend script fails, related to stdout?
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.b4D.bgBpKB@chimera>
In-Reply-To: <Vm51Upp4EV.A.b4D.bgBpKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested rc9 and its still there.

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
> Subject		: suspend script fails, related to stdout?
> Submitter	: Tomas M. <tmezzadra@gmail.com>
> Date		: 2009-07-17 21:24 (52 days old)
> References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4
>
>
>   
