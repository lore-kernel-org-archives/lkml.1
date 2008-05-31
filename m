Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYEaTye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYEaTye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbYEaTyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:54:18 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:39910 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbYEaTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kAYbDjTCo5sv6BdknINTCQ6vACykVca5M6uEcmFNKOT4ETQP/bfItnHK55b8+JIZuvdlHXBIuafd6v7fhmh9b/3tom+e3JqGu2Re0RmWRzrmKCBkL+/lVaWt6SHh88lufZeMQmFBEPJv/vOZADE+SktxTRvUJxb4lts+ATRz9cQ=
Message-ID: <dd18b0c30805311254l2a0cd133je9882e497711cb8e@mail.gmail.com>
Date: Sat, 31 May 2008 19:54:17 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI : EC: GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <UJSav77TyUB.A.A5E.JsZQIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <UJSav77TyUB.A.A5E.JsZQIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 5:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI : EC: GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (16 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
>                  http://lkml.org/lkml/2008/5/25/195
>
>
>

I'm still seeing this message with 2.6.26-rc4. or latest git pulled on thursday.
regards;

-- 
Justin P. Mattock
