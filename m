Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXD0Aay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXD0Aay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXD0Aay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:30:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:35683 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbXD0Aax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uLn/mbpLUBQbtinRSooyXYr2EFYL/GXn9uKw+KCn+3zTqYfNqb3zpO8Ro8YWH6v5jsoxwJNydyshYEkxh7zV6QCirQcmQCYdkjC1jdqta9HHZSOcn6SGRcwKtjyLHvVKwgZG2jHxJ4hXbwqEbW3W35OkcTXG3P3wuNjNoWR5udo=
Message-ID: <768a59a70704261730hbe4a987oa54f65e85d0ceda4@mail.gmail.com>
Date: Fri, 27 Apr 2007 09:30:51 +0900
From: "l l" <happyarch@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: linux-2.6.21 and __udivid3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070426175526.GR3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
	 <20070426175526.GR3468@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the late, i was in my bed.

> I assume this is a plain 2.6.21 from ftp.kernel.org?

Yes.

> Can you reproduce this with gcc 4.1?
> If yes, please send your .config .

I don't, i think i have to go back to gcc-4.2.0 which was fine with
linux-2.6.21-rc7.
It will be same to 2.6.21.

TIA
