Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZHFOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZHFOga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZHFOga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:36:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:22123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZHFOg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GhGg31vNl6t9LRcpXt7awJEWeOZeqsjrRUMKDwiWsXPMXJ2Q9jVCqHQrJy0BHhPhwk
         uud34tmhehqLSSToFKvpO5zAu/13/QpZ7USRwim8EcfMo0RbH7tTJGOAHFopDReSqVYq
         K+1kY4R0nEqV1eAXPTk4qsBelHzJiZZs1uk8w=
MIME-Version: 1.0
In-Reply-To: <20090806072728.GE984@nokia.com>
References: <quadros.roger@gmail.com>
	 <1249503951-11713-1-git-send-email-quadros.roger@gmail.com>
	 <20090806072728.GE984@nokia.com>
Date: Thu, 6 Aug 2009 17:36:28 +0300
Message-ID: <b90c0690908060736l271b1ec1w7fe0cea2fa8ce65a@mail.gmail.com>
Subject: Re: [PATCH v5] [RESEND] regulator: Add GPIO enable control to fixed 
	voltage regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: felipe.balbi@nokia.com
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/Makefile b/Makefile
>> index 0d46615..b2ba5ef 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,7 +1,7 @@
>>  VERSION = 2
>>  PATCHLEVEL = 6
>>  SUBLEVEL = 31
>> -EXTRAVERSION = -rc5
>> +EXTRAVERSION = -rc4
>
> nice!! :-p
>
> --
> balbi
>

oh no..
bad day :(
