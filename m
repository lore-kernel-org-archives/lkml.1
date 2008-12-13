Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYLMOIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYLMOIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYLMOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:08:39 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:57604 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYLMOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D5bll9dDeYYmDbvYX2x7Z/wPUmaNxThIOSKAipAxsB3BLPS44qOG36BlbnHpJybM9r
         VeKdalnuD5XURgWq0tojAK1RNIS+Xb2bs1fgKfixJFO8yyNTFU4GGlVg4sjQDJJbeOJo
         X4DImKWYeSok2IeEO51mIn5OUjyCs6hFueWBA=
Message-ID: <40f31dec0812130608x73266375n7b3367938ad687b8@mail.gmail.com>
Date: Sat, 13 Dec 2008 16:08:36 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Cc: "Bob Copeland" <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <1229174904.4964.5.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
	 <1229174904.4964.5.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Maxim Levitsky <maximlevitsky@gmail.com>:
>
> Hi,
>
> Indeed gpio #3 controls the led.
> I patched ath5k to use it, and led works now fine.
>
>

Please share your patch with the rest and also post an lspci -vnn for
your card so we can handle this in a generic way




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
