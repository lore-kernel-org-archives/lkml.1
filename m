Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758955AbYLPXYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYLPXYj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYLPXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:24:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:38988 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYLPXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gcrabWFZ1ieyl1PTWdRj4aPV/Sc70mPScFvLcAzl1P+mSKPNeZeSWIubpSHZ/P54q9
         YfcK2+bkhuGnIn2d/iJ86gzayzBBbNI/5nXwcgn+9h9swaVo7E3Wtub7aeVUSDw02cfe
         gCJ1gp6QdhKaafY3qUrAjejZMH+Sdwbr3ZIPs=
Message-ID: <b647ffbd0812161524r124365c3y3e6e232ad360ab75@mail.gmail.com>
Date: Wed, 17 Dec 2008 00:24:22 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 0/10] x86: microcode_amd: fixes and cleanup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0812161522t361cfbf5x80fd836ad99607f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216180639.GG7013@alberich.amd.com>
	 <b647ffbd0812161522t361cfbf5x80fd836ad99607f6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/17 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> Hello Andreas,
>
>>
>> Following a small series of patches to cleanup microcode_amd. Patch 1
>> might be of interest for .28. But I don't know whether you are willing to
>> apply the whole series for .28.
>>
>
> I wonder if you see a problem with the scenario described here
> http://bugzilla.kernel.org/process_bug.cgi
> on any of your systems?

here is the correct link:

http://bugzilla.kernel.org/show_bug.cgi?id=12100


-- 
Best regards,
Dmitry Adamushko
