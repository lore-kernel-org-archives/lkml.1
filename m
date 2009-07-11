Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZGKLKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZGKLKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZGKLJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:09:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:9309 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZGKLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wvoEjTewYO+/ZkzI3OAmjsF7NMbU4/HvSaCGdmohUXS/OllxMqXuDUqdyf6fgFFyAM
         P545bbkmgGZeDQna4dppIp8fj8ugadQ1d89z153nsHWTdMTP30SQM3R0CqGxADcH3XTd
         0N/63fu8fNTBfp2by+Qv4mf1IpTrHEZyKU534=
Message-ID: <4A5872FD.8040500@gmail.com>
Date: Sat, 11 Jul 2009 13:09:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>, Julia Lawall <julia@diku.dk>,
       gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>	 <4A584A94.5010105@gmail.com>  <1247307444.3032.2.camel@hpdv5.satnam> <1247308323.3032.5.camel@hpdv5.satnam>
In-Reply-To: <1247308323.3032.5.camel@hpdv5.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 12:32 PM, Jaswinder Singh Rajput wrote:
> And more funny thing is that all functions are global in this file.
> 
> Greg, can you please check the scope of these function, why all are
> global.

Why don't you do that? I think patches are welcome :).
