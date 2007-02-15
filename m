Return-Path: <linux-kernel-owner+w=401wt.eu-S1161035AbXBOTho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161035AbXBOTho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161047AbXBOTho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:37:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:44537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbXBOThn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lHs29D3tehHRJYvj2iYA0bPR0qOaEUHfFT0TdahMgepgqcIvfBOlYgZJ3R6iyaDF4MyS5cJfX5G5oO07T4cizezLYCdsvOrWJx1bLHA/C65RJS9+p1VXScubPFyBHFNRSJVkKjjRItfFPz2FCL3+FioTJ9x7G0BeszUbldQNAyU=
Message-ID: <df47b87a0702151137m6fd02865le424657fed242ca1@mail.gmail.com>
Date: Thu, 15 Feb 2007 14:37:38 -0500
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: libsata tests started
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702150818l1b270714oc974c56e6d90f4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>
	 <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
	 <20070210203504.129b35ac@localhost.localdomain>
	 <8d158e1f0702101232q244a890fg450aa039689fcb3a@mail.gmail.com>
	 <8d158e1f0702101404s457fd1fx72f838021d7831b7@mail.gmail.com>
	 <6bffcb0e0702101423xd854b59x22d1d08f89ffa42c@mail.gmail.com>
	 <8d158e1f0702130031n75926241q83733cceb4080aa9@mail.gmail.com>
	 <45D3E854.6020701@gmail.com>
	 <8d158e1f0702150818l1b270714oc974c56e6d90f4f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> On 2/15/07, Tejun Heo <htejun@gmail.com> wrote:
>
> Yeah and about the libsata/libata thingy, it is libata of course :)
> libsata I will test later on, so be prepared allready for more ranting for me.

It is all libata! Whether pata or sata, it's still libata. The way the
distinction is made is by saying libata pata. So, there is _no_
libsata!

root@section 14:34:37 /sources/linux-2.6.20/
 $ grep libsata * -r
root@section 14:37:49 /sources/linux-2.6.20/

All clear now?
