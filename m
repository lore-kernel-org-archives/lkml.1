Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXBXKKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXBXKKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933474AbXBXKKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:10:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:47131 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbXBXKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=orAddRGdBas86+muEiAe5fYb9+G17DVVgWnA4cenq/5nUJ8OceAQVkz7ZqIQA6uO5oqTxIRDIeAt0PQjBfXT3wfl2aIwCO9UJapwnBA6Jg83Mg9ZQ2N8gPqL54poibYpIwKucLxG2PxEsftG/HJDkMG05Wp8ebsb/OxNHTt2zCk=
Message-ID: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
Date: Sat, 24 Feb 2007 11:10:12 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [QUESTION] Sata RAID
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quick question,

Since I am going to open my server today to do some pata tests (for
the weird detection problems people are giving me fantastic help with,
no sarcasm, I really mean it) I thought: why not add two 320GB SATA
disks on the SATA controller that the mainboard has.

I am wondering: should I use the onboard RAID function? Is this
supported by Linux? I remember back in "the old days (TM)" there were
seperate (spelling) drivers for ataraid, how does the current 2.6
branch cope with the RAID functions of modern motherboards?

I am aware that it is NOT hardware raid, the raid is done in the
driver, which is why you need this fancy boot disk before installing
Windows on your RAID set.

Or would you suggest me to stick with MD devices?


Cheers,

Patrick Ale
patrick.ale@gmail.com

"kun kasvan isoksi, halun olla poro"
