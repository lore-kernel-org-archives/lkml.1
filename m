Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZDGLDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZDGLDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZDGLDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:03:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:42381 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZDGLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rn0AKNxFaBIWGR8K7GP4u8ZO1p4REz10R1dEO3qr1H4yfU/a1RcLshzRxrxfZCqI9O
         mvY11BUM7EG7opwyuR36YFszcOyBYX9vhg2/kUMB9BQrkwXWaW9Kypb8pDO2qpn3bRwr
         PBjm1u/FwU7TIatiVGuuirjcIdEpXbwRgoLXc=
Message-ID: <49DB32EE.4050309@gmail.com>
Date: Tue, 07 Apr 2009 13:03:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Bug #12908] acpi_ex_extract_from_field -- div by zero
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.l9H.UGn2JB@chimera> <alpine.LFD.2.00.0904070008140.5698@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904070008140.5698@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2009 06:09 AM, Len Brown wrote:
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> 
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12908
>> Subject		: acpi_ex_extract_from_field -- div by zero
>> Submitter	: Jiri Slaby <jirislaby@gmail.com>
>> Date		: 2009-03-15 10:47 (23 days old)
>> References	: http://marc.info/?l=linux-kernel&m=123711408225013&w=4
>> Handled-By	: Lin Ming <ming.m.lin@intel.com>
> 
> This is unreproducible and now marked closed.

s/un/hardly /. As I wrote earlier this usually happens after few days
being off which makes it peculiar.

> The theory is that somebody (else:-) scribbled on random kernel memory...

Might be, this will probably be hard to catch :/.

Or even a HW malfunction...
