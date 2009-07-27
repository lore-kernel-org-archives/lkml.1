Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZG0B6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZG0B6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZG0B6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:58:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:38177 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZG0B6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=clk16UbthAoZgDXCvlNwHRNil+Ul/L5DrZEgzA2Zph0VQS8kn6ILDScYzZKeQohNvJ
         ITHkxbAVhou7kv2DsMsmgEJdkPTyByGq1tfBWvqoOZiVhfuJyansabpzRYnwaG6SbCkC
         ABssdHe1SD8HZG8Ae9obyPNzsFW/iHmktlSEM=
MIME-Version: 1.0
In-Reply-To: <3zAHs5O6maO.A.IVD.fHObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.IVD.fHObKB@chimera>
Date: Mon, 27 Jul 2009 09:58:35 +0800
Message-ID: <2375c9f90907261858l13abb28fk961aa5e4e71d0cda@mail.gmail.com>
Subject: Re: [Bug #13806] system does not boot due to device-mapper error
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Roman Shtylman <shtylman@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13806
> Subject         : system does not boot due to device-mapper error
> Submitter       : Roman Shtylman <shtylman@gmail.com>
> Date            : 2009-07-21 00:03 (6 days old)

Proposed patch:

http://patchwork.kernel.org/patch/33534/
