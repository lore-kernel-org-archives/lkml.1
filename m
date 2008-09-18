Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYIRWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYIRWIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYIRWI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:08:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50292 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbYIRWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WcUkVYDP3qFSrMua9xaEwHBJIlumbNlUbNp2uYnqbMe+/ee/dfDCFuwG5evUn9oJI8
         OSCCQbJh292Ns3sH3DUaGr6w0cTigOcB1vqz4TEGMYDRWxhaPFRSd9YPSZMVZKwN05bF
         7lwI+Vxp7sZYS4Glqi9EKo3Rgs+evhAdnE3dc=
Message-ID: <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
Date: Thu, 18 Sep 2008 15:08:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <20080918220102.GE7408@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
X-Google-Sender-Auth: 31eced29d51e600e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 3:01 PM, Luis R. Rodriguez

>> Which is far more important, I agree. It's annoying to get speeds
>> <802.11b on my pre-802.11n capable chipset and network. ;)

Oh and you should at least get some 11n rates, just not aggregation :)

  Luis
