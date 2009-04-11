Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZDKTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZDKTE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbZDKTEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:04:20 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45774 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZDKTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=D60BU41BgJXVq5Kv8F/JjUXs3naiK2kGsss3MYb2qCFCbYCwymGrBOBUiRG/n/3JXy
         b86vgZ5yf2y0a+5tH/aqWoYZnqu9DdOKvULLma0Q9zWWvAWSmM5Hbw2lPdknnfKYWNsN
         whCLMAI0RVU7/mdwn9EXBIoyE3keB+Rp8URvw=
MIME-Version: 1.0
In-Reply-To: <20090411190121.GA18885@orion>
References: <20090411190121.GA18885@orion>
Date: Sat, 11 Apr 2009 23:04:18 +0400
Message-ID: <a4423d670904111204x2108ac9eyd479b5e1c5ecd9c9@mail.gmail.com>
Subject: Re: [PATCH 1/1] agnx: replace print_mac with %pM
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/11 Alexander Beregalov <a.beregalov@gmail.com>:
>
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---

Sorry, Subject should be
[PATCH 1/2] Staging: agnx: replace print_mac with %pM
