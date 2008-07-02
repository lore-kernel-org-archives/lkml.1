Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYGBQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYGBQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYGBQaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:30:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:9223 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYGBQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R07dP29RQWi0zNPlh5d4h0TFKHL55HXZ1HlwAkjRFou40xb/gPOIWUgjye9xnHtI5x
         OWxU+zJUX4rTAdpjn8IqGjH2in9srmo6dg2HBa7rebLPmr+6XhdULYWj4ubwKjcFzzHx
         DVBdJNHcImtQ63XGk35rZpDESmYJyjCaVLCw4=
Message-ID: <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>
Date: Wed, 2 Jul 2008 16:30:11 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: dsdt buggy acpi
Cc: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <20080702115527.GA3396@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	 <200807011619.53339.rjw@sisk.pl>
	 <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
	 <20080702082555.0959ef2b@linux360.ro>
	 <20080702100935.GA699@srcf.ucam.org>
	 <20080702144820.29f7d43d@linux360.ro>
	 <20080702115527.GA3396@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 11:55 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jul 02, 2008 at 02:48:20PM +0300, Eduard - Gabriel Munteanu wrote:
>> On Wed, 2 Jul 2008 11:09:35 +0100
>> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > We've made a huge number of workarounds for buggy DSDT
>> > implementations.
>>
>> Of course, I myself used a custom DSDT for my laptop. But I was saying
>> that these workarounds generally do not belong to the kernel realm.
>
> Of course they do. Nothing else is going to fix them up.
>
>> This isn't the regular "Pentium F00F bug" stuff; instead bugs in DSDTs
>> consist of compiling issues, non-standard compliant, plainly bad
>> code, Windows-only stuff, which can all be unique for every model of a
>> laptop for example. While the kernel may be able to get around some of
>> that stuff, the kernel won't have any Asus, Acer etc. specific
>> workarounds.
>
> Windows doesn't have any Asus/Acer/whatever workarounds either. We just
> need to be compatible with the Windows implementation. There's a
> minority of cases where that isn't good enough, but almost every DSDT
> issue can (and should) be handled by Linux if the machine works under
> Windows.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Hello; what info is supplied with EFI i.g. I'm using a macbook pro.
After looking at:
http://acpi.sourceforge.net/dsdt/view.php I was unable to locate
anything with apple, or at least
couldn't find the manufacture number.
If somebody has already done this, I was wondering if it would be O.K.
if I can attached my dsdt.dsl with the errors,
and my explanation of what I changed, just so If I did something
completely wrong
I can  adjust it, So I can feel at ease knowing that it's correct.
regards;
-- 
Justin P. Mattock
