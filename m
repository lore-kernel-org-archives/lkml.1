Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYLPVRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYLPVRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYLPVQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:16:57 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:39320 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYLPVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tpT1BGqhz+1MKZOuhFuhYlTkJGyXdUjqAOtz7uIona2HsihjtTFj9sN9lw/Np6caBx
         nUqy2rd27LidMLkoT/mq7qyXAPYTkL1CduQZsZAJxYRUsybeSyc8aaYbm9ei/QuSMyw4
         HUHJBUJRdoPuWkV9Hz8aMUPasS/BFxHxx/t6E=
Message-ID: <49481B29.10001@tuffmail.co.uk>
Date: Tue, 16 Dec 2008 21:18:33 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: hibernation bug - swap goes AWOL
References: <4947ED8C.1010709@tuffmail.co.uk> <200812162206.53744.rjw@sisk.pl>
In-Reply-To: <200812162206.53744.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Well, I'm not sure if the bug is in the hibernate code or in the swap code.
>
> Anyway, please file a bugzilla report about that.
>
> Thanks,
> Rafael
>   
Ok.

http://bugzilla.kernel.org/show_bug.cgi?id=12239

Thanks
Alan
