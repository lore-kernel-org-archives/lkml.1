Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZCOTjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZCOTjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbZCOTca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:32:30 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63799 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbZCOTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x96xYvvlYfwNz4VD/YbYELzjL7hBSZf2mWamQXFTxzBLSjHgqnnND8W92VeuDjRFAY
         xLjFkNATZ4WlLDBGdRVXHA9KJ+6S3E22GHIw8Zf52Bm0G456j7UCCdIQ69QuCsuRyvbf
         P4XZKPU3uSimxsM5N/cD97wp2biHrYHmT1N7o=
Message-ID: <49BD57C2.1060906@gmail.com>
Date: Sun, 15 Mar 2009 20:32:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Moore, Robert" <robert.moore@intel.com>
CC: Len Brown <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
References: <49BCDCAA.8040309@gmail.com> <4911F71203A09E4D9981D27F9D83085814F8A39D@orsmsx503.amr.corp.intel.com>
In-Reply-To: <4911F71203A09E4D9981D27F9D83085814F8A39D@orsmsx503.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.3.2009 20:08, Moore, Robert wrote:
> Can you please send or post the acpidump for the machine? Thanks.

Sure:
http://www.fi.muni.cz/~xslaby/sklad/adump
