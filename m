Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYJ1T7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYJ1T7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYJ1T7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:59:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:32266 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYJ1T7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DEw2rNjIiqhBO/y4bp2/4XuZ8/PRRd3tZaxgmsh5pIu8c9y2tQUib5icIgi9zGxniP
         d0PUdK/7USdrCALcpRt4yQRr/jNsDTddhA+2s5WVJPHIZXnnBA0ONI0crmt6Uqv/lAaz
         U9FhVLD+x4KUUtkm/1xmzpiARLIqGtuSCFCCw=
Message-ID: <b637ec0b0810281259y4ef79c53pae6a8aaf2a94f6d2@mail.gmail.com>
Date: Tue, 28 Oct 2008 20:59:19 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: ACPI warning in 2.6.28-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI mailing list" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <4911F71203A09E4D9981D27F9D8308580ADBF12C@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0810241509j43a6bfc9q506dc16a612e7f06@mail.gmail.com>
	 <4911F71203A09E4D9981D27F9D8308580AA800C4@orsmsx503.amr.corp.intel.com>
	 <b637ec0b0810250257oc9718f0yb6fc9fc2b53e80fc@mail.gmail.com>
	 <4911F71203A09E4D9981D27F9D8308580ADBF12C@orsmsx503.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, thanks.
regards,
Fabio

On Tue, Oct 28, 2008 at 8:40 PM, Moore, Robert <robert.moore@intel.com> wrote:
> Thanks.
>
> The Linux battery driver can in fact handle the buffer where there should be a string, so this warning can be ignored.
>
> The acpidump is very helpful for characterizing the problem, and we are investigating the proper course of action.
>
> Bob
>
>
>>-----Original Message-----
>>From: Fabio Comolli [mailto:fabio.comolli@gmail.com]
>>Sent: Saturday, October 25, 2008 2:57 AM
>>To: Moore, Robert
>>Cc: Linux Kernel Mailing List; ACPI mailing list; Len Brown
>>Subject: Re: ACPI warning in 2.6.28-rc1
>>
>>Here you are.
>>Regards,
>>Fabio
>>
>>
>>
>>On Sat, Oct 25, 2008 at 12:34 AM, Moore, Robert <robert.moore@intel.com>
>>wrote:
>>> Please send the acpidump for the machine so we can look at the method.
>>> Thanks,
>>> Bob
>>>
>>>
>>>>-----Original Message-----
>>>>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>>>>owner@vger.kernel.org] On Behalf Of Fabio Comolli
>>>>Sent: Friday, October 24, 2008 3:09 PM
>>>>To: Linux Kernel Mailing List
>>>>Cc: ACPI mailing list; Len Brown
>>>>Subject: ACPI warning in 2.6.28-rc1
>>>>
>>>>Hi all.
>>>>As the subject says:
>>>>
>>>>ACPI Warning (nspredef-0858): \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Return
>>>>Package type mismatch at index 11 - found Buffer, expected String
>>>>[20080926]
>>>>
>>>>No functional problems so far.
>>>>--
>>>>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>>>the body of a message to majordomo@vger.kernel.org
>>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
