Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZJZUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZJZUIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZJZUIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:08:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:34724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZJZUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rxCFPyaF3iNTMFjAlbOTGHnhht1JMYcoRYFpZ/t/tIAURQ2MKrLXajN1tf02QFMrlz
         KgwZ0AJzas4a4kqOm8iPPnJiqPbT6nuCsaKSOh3zr4AjJJ4NnXBYFHQplCoUQpFNkbLb
         1+cLkMPK9Zhr6BcdNpLpKj1dkOwSSYbqVYQWY=
Message-ID: <4AE601B1.7050000@gmail.com>
Date: Mon, 26 Oct 2009 13:08:17 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14483] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x54/0xca()
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.hyE.2qe5KB@chimera>
In-Reply-To: <6dRYo8ss7vL.A.hyE.2qe5KB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> Subject		: WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x54/0xca()
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2009-10-25 19:58 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
>
>
>
>    
yeah this happens on the first go of
echo mem > /sys/power/state
for both of my imac's I have here.
(on the second  try, this message does not appear)

Justin P. Mattock
