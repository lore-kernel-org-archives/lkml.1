Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXHQQYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXHQQYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765747AbXHQQYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:24:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27315 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbXHQQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DJOx7bcbvQQadBU/rTEHlAphVs4W62JrTcuq1K+lL9fPDAxi+C3ba7l3f/tUdgzRGE6F25aiV4h22GC4MKEORjTf6c9auWlQGICB7GKuc5eZhmSwDTsfJjO+r5ldGNqSPvrnMM9S5Md6hVtfbz8HS7T4ElFovNfrVL6MMScKjeY=
Message-ID: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com>
Date: Fri, 17 Aug 2007 18:24:17 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.19 porting
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I have built up a software virtual prototype system with ARM11MPCORE.
my system is similar with realview_eb_mpcore. but my system is
simpler, which has only a mpcore , uart0, console,timer0_1, and
memorys.

I want to run kernel 2.6.19 on it. I have done some modification, and
now I can just print out some information onto the console, and stuck
at

<7>Calibrating delay loop...

Could you guys give me some suggestion that what other adaptions
should I do according to my system?

any suggestion is welcome:)

thanks,

regards,

yang
