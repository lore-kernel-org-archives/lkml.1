Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYHJAeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYHJAeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYHJAeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:34:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:13280 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYHJAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ck4CQmctBLYt6b06A+EBkBwf1ipyAQnC9zh+Am8rXCnyPXLZaO84bUvMjvlEla31N4
         Uwf7ZRfztOa+VQPYYHPHCmpSr9XqR6oJvvib0lQQ3WPUAmBPgnEOS0QrZwvvIqJ8Sdaj
         z4R/XCEDOAWu8i7+v/9za/bKTcI9uLgLI2QGU=
Message-ID: <82e4877d0808091733u34bc4a3dl76dbca4737543c06@mail.gmail.com>
Date: Sat, 9 Aug 2008 20:33:57 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #11277] BUG kmalloc-64: Object already free
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <dd18b0c30808091725s5974befdp4b57fe54d3d6e255@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.TX.0CjnIB@albercik>
	 <dd18b0c30808091725s5974befdp4b57fe54d3d6e255@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 8:25 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11277
>> Subject         : BUG kmalloc-64: Object already free
>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>> Date            : 2008-08-06 21:21 (4 days old)
>> References      : http://marc.info/?l=linux-kernel&m=121805862910241&w=4
>> Handled-By      : Parag Warudkar <parag.warudkar@gmail.com>
>> Patch           : http://marc.info/?l=linux-kernel&m=121814402609514&w=4
>>
>>
>>
>
> I think this bug report can be closed.
>

Patch is not in mainline yet - should be closed after Andrew pushes it to Linus.

Parag
