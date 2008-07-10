Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbYGJKuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbYGJKuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYGJKuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:50:40 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:33749 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYGJKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MDg4ZSqVl15JqhpjCFNxB/QudLXaMm4Tl4UUFqCypcKdIGEiUbpix4m75YZezp+fdo
         MkOeXs4wJJ7NCh3hB5UCXIZec5lfshZJ7PvMQScMVbiq4dDH4OReDLejOQdCop4Iho7J
         /W0b27UK927OcjAvXHftZy/QRHSgKrLkb6+8Q=
Message-ID: <1ba2fa240807100350n57e6121en46cc0febf12b6e50@mail.gmail.com>
Date: Thu, 10 Jul 2008 13:50:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1215685335.3483.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709190915.GA8238@tuxdriver.com>
	 <1215685335.3483.5.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 1:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> 0900  Status Reports
>>       Overview of where things stand today
>>       - 802.11n
>>       - QoS/Multiqueue
>>       - Mesh mode (802.11s)
>>       - RF kill
>
> And spectrum management (Tomas) please.



>
> We've seen initial patches that add a bit of infrastructure, but aren't
> using these things yet.

Hope to submit all the patches before symposium.
The whole package is already visible in iwl5000 branch of
iwlwifi-2.6.git Need to clean it up and submit.

Thanks
Tomas
