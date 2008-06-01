Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYFARUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYFARUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYFARUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:20:46 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:25004 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYFARUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xvj75vyxabjgPTYyxviq5dUdlt6Vut5SA/8ZJapFUxAT4KwPfyRjL2Rvxmlb5uQJTLFWy9a6LhBaaJxCCeSw7vkeHFMPb9H6V3PCOlvyUfauli48cTz9mOfowj2CBMVcST80q39wuiVmTGTNNycExVbu0RTv9FRJGAOFqefvFXE=
Message-ID: <dd18b0c30806011020i5f878f77qff504ffbe351b835@mail.gmail.com>
Date: Sun, 1 Jun 2008 17:20:45 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806011240.56514.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <dd18b0c30805311510i14c2d3ffi9b94e68d5b539677@mail.gmail.com>
	 <dd18b0c30805311621w7d06a6a5l3ab7e5c0a38132eb@mail.gmail.com>
	 <200806011240.56514.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 10:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Sonntag, 1. Juni 2008 01:21:44 schrieb Justin Mattock:
>>  { USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
>
> This one.
>
>        Regards
>                Oliver
>

Cool, I'll give it a go.
regards;

-- 
Justin P. Mattock
