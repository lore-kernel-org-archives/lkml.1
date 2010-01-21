Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158Ab0AUORX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0AUORX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655Ab0AUORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:17:22 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36042 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0AUORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tXEtTftrGrlsOicMOAeI/FXkxBmkyX14cWVC8hFjrkF8pU2QOFu6BA2j+s1PIrqN5r
         PPsrkJhAe7DVBcPRDO59lDZ1y9lxJXR4L3ByI6hXBmN1D3pjjHg3mdXr6skl3qONqZTb
         k3MxplffMA5/Fuu5388bWrEL9e7stusy0cMKM=
Message-ID: <4B5861EA.60206@gmail.com>
Date: Thu, 21 Jan 2010 15:17:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: limits tree fetch error
References: <20100121101928.014ae274.sfr@canb.auug.org.au>
In-Reply-To: <20100121101928.014ae274.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 12:19 AM, Stephen Rothwell wrote:
> Today's linux-next fetch of the limits tree produced this error:
> 
> decibel.fi.muni.cz[0: 147.251.50.163]: errno=Connection timed out
> fatal: unable to connect a socket (Connection timed out)

Hi, I think they have been doing some network updates. If you still
encounter problems, please let me know.

thanks,
-- 
js
