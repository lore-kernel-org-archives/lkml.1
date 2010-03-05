Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0CEPTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:19:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:23868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab0CEPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s8+87r54xcWbeZ+37Czf+iH0cwC857f7v+GK6qLKIcNIVXWASk1xG+KiVlvidZLagN
         s8EZta//X+KVPcTcLt1cL5Dsrkg3glPj4I4EOKnPPVMfuDnG91WR4aneQTBGwz7SQ89H
         MHqRN6IZQzBYFNffacQpe1WXk2oi47U7R1F6U=
Message-ID: <4B9120F2.2020000@gmail.com>
Date: Fri, 05 Mar 2010 16:19:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jakub Narebski <jnareb@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Sixt <j.sixt@viscovery.net>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
References: <4B90CBE5.9090102@viscovery.net>	<1267780845-10547-1-git-send-email-jslaby@suse.cz> <m3pr3jkq26.fsf@localhost.localdomain>
In-Reply-To: <m3pr3jkq26.fsf@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 11:43 AM, Jakub Narebski wrote:
>> +!/.gitignore
>> +!/.mailmap
> 
> Actually you want to *not ignore* .gitignore and .mailmap (and
> .gitattributes which is missing here) anywhere, not only as top-level
> file.  So .gitignore and .mailmap should not be prepended with slash.

<and moved out of the 'Top-level generic files' section then>

-- 
js
