Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZBJJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZBJJS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZBJJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:18:09 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:34341 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZBJJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VuZRQmv5I2UWNZJYO5kW7cQKN89kwssee9Zgg1Usvj6D1j2qgb1MAuZ0ul2JRSXTeS
         3aYV7N5WTS0l9Dx/jn+BBS2iI9lA0sBow4t0+bqE6fs+47oCqN5aiKtxxgqiE2V75xeI
         DF7PJdqTBLAKI03TZVA4CSkuYY2uNH3awG1kA=
Message-ID: <4991464C.2050500@gmail.com>
Date: Tue, 10 Feb 2009 10:18:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cassini: i reaches 0, not -1.
References: <4990AA32.1010004@gmail.com> <20090209.175600.191087624.davem@davemloft.net>
In-Reply-To: <20090209.175600.191087624.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Mon, 09 Feb 2009 23:12:02 +0100
> 
>> With while (i-- > 0) { ... } i reaches 0, not -1.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Does it?

No, you're right, sorry, please ignore :-/
