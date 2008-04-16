Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbYDPKvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbYDPKvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYDPKvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:51:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:2773 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbYDPKvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oOsk/JwPH21Y8YY+Ohkrrx22kvEp8d3hJgCmKRAf2czlYjG65sCsFeTLMMnL4/K+n26P33TQOvvm1qOkEkznUcw9LHTp3cLtMmnhzR3NoC5liWBy6PAUR68Yz1I62aGWYxtR5uOBOlFmjW7WVfW/Vvqbh1pIApd6rL38aOy1M/Y=
Message-ID: <35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com>
Date: Wed, 16 Apr 2008 13:51:37 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: hci_usb: remove macro code obfuscation
Cc: "Andrew Morton" <akpm@osdl.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       maxk@qualcomm.com, linux-bluetooth@vger.kernel.org
In-Reply-To: <20080416104257.GA1621@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416104257.GA1621@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 1:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
>  I had trouble figuring out what the code does. atomic_inc/dec
>  management is actually pretty simple, but it is needlessly obfuscated
>  with macros. Fix that.
>
>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>
>  I had trouble figuring out what the code does. atomic_inc/dec
>  management is actually pretty simple, but it is needlessly obfuscated
>  with macros. Fix that.
>
>  Signed-off-by: Pavel Machek <pavel@suse.cz>


Got it from the first time;)

Do you think that now code looks better? As for me it's not...

V>
