Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbXLIPrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbXLIPrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXLIPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:47:08 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:56503 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXLIPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WUnoZmZZWNIg7pL/u4KKI9LW+fwWTgcapE4v/QRWeDVu9TfL5DwkONwheeoMhwuO3ip74uNi+D3ac1hAaAAENPoONi1PXfqo1AT8b3f04S83Ltn4nepiomD3AnQ+JNsv2Sr8WXIHBnJK3+RWlF0C9quJEp7zQ7VS6X2ZHOXYXUk=
Message-ID: <475C0DF1.50108@gmail.com>
Date: Mon, 10 Dec 2007 00:46:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <20071208101256.GA25807@rhlx01.hs-esslingen.de> <20071208022001.155e0c52.akpm@linux-foundation.org> <20071208105557.GA27646@rhlx01.hs-esslingen.de>
In-Reply-To: <20071208105557.GA27646@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
>>> Does this report now win me the lucky draw, pretty please? ;)
>> nah, you have to cc the acpi guys to get a prize ;)
> 
> Thought so shortly, but missed it.
> 
>> Andreas, please do separately report that WOL problem too..
> 
> Local setup issue only, at least this one *isn't* a 2.6.24-rc regression. ;)
> 
>> Our list just reached 30.
> 
> Oh, so this is in fact a separate issue? Wasn't sure, couldn't do
> enough analysis of similar cases.
> 
> Will test any (already submitted!) suggestions ASAP.

Please post full kernel boot log and the result of 'lspci -nn'.

Thanks.

-- 
tejun
