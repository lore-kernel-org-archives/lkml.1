Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZG0B7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZG0B7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZG0B7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:59:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:58413 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZG0B7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sdx29PdiYc+hWKhBXrg2tagPnz7HVgK/rGssv+CYmsPSDxZCFmRQ4tZc+6DbMGL5Um
         b5SjK7YIwZfY4S7t2gttlii3kcfnmO3J6sRzFzv8PbNVvsXj+Fafv/idlYNSheOCXqxX
         ed1b5IEU9dTZ7SKqdcQID0eLA3mh3AShDTLX8=
MIME-Version: 1.0
In-Reply-To: <H5-1lZIIeYK.A.0KH.4XObKB@chimera>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	 <H5-1lZIIeYK.A.0KH.4XObKB@chimera>
Date: Mon, 27 Jul 2009 09:59:22 +0800
Message-ID: <a8e1da0907261859t3ca96850oc05b2c2b96169321@mail.gmail.com>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
From: Dave Young <hidave.darkstar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 4:45 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).

It has been fixed, at least I did not see it in recent rc4 kernel.

>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
> Subject         : suspend/hibernate lockdep warning
> Submitter       : Dave Young <hidave.darkstar@gmail.com>
> Date            : 2009-06-02 10:00 (55 days old)
> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4
> Handled-By      : Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Patch           : http://patchwork.kernel.org/patch/28660/
>
>
>



-- 
Regards
dave
