Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGOR4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGOR4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZGOR4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:56:42 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:51417 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbZGOR4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xv8YmYkETAdTDc+kkDSseUIOW9s3dZ47YdTOmwD//FAZz2viSOKIUuW0SyjW5G9isz
         Q9QVU1CmpgN5slYl2GSNREIpdA4mAZEMgwjjRFqQUpBQBjQdsxzwceqJpl3GXjDTh/GD
         oZD82fi0FPgCZvKMWSIRDlyEIhc4iF3viRBtM=
MIME-Version: 1.0
In-Reply-To: <4A5D82EA.1070002@turknet.net.tr>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <dWkuWjWDsSB.A.8EE.Q0oUKB@chimera> <4A5D82EA.1070002@turknet.net.tr>
Date: Wed, 15 Jul 2009 19:56:37 +0200
Message-ID: <8db1092f0907151056u6654cf4bp2fe36d3fa4081a07@mail.gmail.com>
Subject: Re: [Bug #13727] Cannot Recognize Empty DVD Media
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/15 Tarkan Erimer <tarkan.erimer@turknet.net.tr>:
> On 07/07/2009 03:01 AM, Rafael J. Wysocki wrote:
>>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13727
>> Subject         : Cannot Recognize Empty DVD Media
>> Submitter       : Tarkan Erimer<tarkan.erimer@turknet.net.tr>
>> Date            : 2009-07-02 16:23 (5 days old)
>> References      : http://lkml.org/lkml/2009/7/2/178
>>
>>
>>
>
> I confirm that, as of Linux-2.6.31-rc3, it's fixed.

I also confirm, that -rc3 works OK.

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
