Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZIAWMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZIAWMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZIAWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:12:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbZIAWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:12:06 -0400
Message-ID: <4A9D9BEE.1010203@zytor.com>
Date: Tue, 01 Sep 2009 15:10:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memleaks, acpi + ext4 + tty
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> 	<43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com> 	<43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com> 	<43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com> 	<43e72e890908310123w5d361ed5tff58a7663044bdcd@mail.gmail.com> 	<43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com> 	<43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com> 	<43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com> 	<20090831193345.GG5631@tuxdriver.com> <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com> <43e72e890908311258y45565a9fo1e739992c00b650@mail.gmail.com>
In-Reply-To: <43e72e890908311258y45565a9fo1e739992c00b650@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 12:58 PM, Luis R. Rodriguez wrote:
> 
> Good news is Linus' rc8 tag *has the same issue* so the reason why
> wireless-testing has it is rc8 *does indeed have it*.
> 
> So Peter, if there is something extra or missing from
> linux-2.6-allstable head it certainly fixed my issues, will have to
> try a new respin of it to ensure it wasn't a fluke. Odd thing too
> though is even my distribution kernel (karmic rc8 generic) works fine.
> 

linux-2.6-allstable head is == linus.

	-hpa
