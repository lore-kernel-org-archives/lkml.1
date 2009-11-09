Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZKIICT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZKIICT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZKIICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:02:18 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62986 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZKIICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dRD14DdGkVY1QXu07t/BhALNIopelJQpIfmdRfzho7+FesUyWjX8EHLW4xX8sGKECB
         fbnDQ0xYpHduwCwnmX0Aad+3kuoZiFVmk9A+cRV2d/GbcXNywWJG31WX1C0roTCuX8H/
         lawywBGY0kamyYT4VqBpvJ96OTm5+NGu7H01I=
Message-ID: <4AF7CC8B.2080400@gmail.com>
Date: Mon, 09 Nov 2009 09:02:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: limits tree fetch failure
References: <20091109103017.6099f588.sfr@canb.auug.org.au>
In-Reply-To: <20091109103017.6099f588.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 12:30 AM, Stephen Rothwell wrote:
> Today's linux-next fetch of the limits tree produced this error:
> 
> decibel.fi.muni.cz[0: 147.251.50.163]: errno=Connection timed out
> fatal: unable to connect a socket (Connection timed out)

Hi, ah, power outages and electricity reconnections. It's up and running
now. Thanks.
