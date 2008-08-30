Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYH3TG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYH3TG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYH3TGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:06:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:44756 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYH3TGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=wX643ke3l2aDeNGA9LBjfltpHXhJWFNjET6M5UgGQTQOmEOXS/7YBeqz+bcbQm8yg5
         fk5U0YjDZaHVIxMcwEr5X3r2uJJA5dw422JePuOfAIz2pPPaAu7IaaIuDO+DrKaC4B6e
         oPZ5MlZKgDJUwa6vwTDQAkb4HzMRf83HrrvdE=
Message-ID: <86802c440808301206u2407b77dx6c7119bc398f9529@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:06:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <86802c440808301111i2880a13eq61155b8c7b1ed3dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17509_15779889.1220123175044"
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808301532.57307.rjw@sisk.pl>
	 <86802c440808300905v5056fe0apdc6e328d99dff090@mail.gmail.com>
	 <200808301915.00381.rjw@sisk.pl>
	 <86802c440808301055o1a8bc6a9iddbc066f016ef6d6@mail.gmail.com>
	 <86802c440808301111i2880a13eq61155b8c7b1ed3dd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17509_15779889.1220123175044
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Aug 30, 2008 at 11:11 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Aug 30, 2008 at 10:55 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Sat, Aug 30, 2008 at 10:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>>>
>>> Could you please rebase them on top of current -git?
>>
>> please check attached quilt series based on linus tree.
>
> there is some problem with fix -v4...on one test machine.
>

this one should work.

YH

------=_Part_17509_15779889.1220123175044
Content-Type: application/x-bzip2; name=reserve_region_v5.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkilrvxa0
Content-Disposition: attachment; filename=reserve_region_v5.tar.bz2

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

------=_Part_17509_15779889.1220123175044--
