Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZILT1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZILT1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 15:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZILT1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 15:27:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48011 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZILT1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 15:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ghx6QZql3cyb8Zj/Kb47vc9sr0RgwyiZBYaVGvodv6e8kxQWAO/UlXg4hqLWF/rmKr
         2kAFPj91d7nppkaz48M/pXfK5Vz/mBlCtHyYF0gclGdRz1sjrWw1mqR4OuQgROX8HdfJ
         b25rzp9cAOh0zZSqmES8C6VQNVNovy+j0jQzQ=
MIME-Version: 1.0
In-Reply-To: <hKF51Pczj6N.A.1CB.q5BpKB@chimera>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
	 <hKF51Pczj6N.A.1CB.q5BpKB@chimera>
Date: Sat, 12 Sep 2009 21:27:11 +0200
Message-ID: <38b2ab8a0909121227k6b6af281i3eaf5213c0ef25a1@mail.gmail.com>
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

On Sun, Sep 6, 2009 at 8:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13328
> Subject         : b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
> Submitter       : Francis Moreau <francis.moro@gmail.com>
> Date            : 2009-05-03 16:22 (127 days old)
> References      : http://marc.info/?l=linux-kernel&m=124136778012280&w=4
>

still in 2.6.31

-- 
Francis
