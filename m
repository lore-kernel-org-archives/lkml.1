Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZKWJ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZKWJ6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZKWJ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:58:51 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36354 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZKWJ6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PXWEVs7ZaWQTy1tBORjCY6vd3xSjnFEMLwqCHowrWCsQ8mIjA5ZVmBDyYhTYyvA33F
         TnsHTWgsVoIkFW3G5un8RTrSFT8gZcP6Fm43Jj/9OPxUcFl/njMvHB3UVl1LhC2XWc4v
         rJzK+0XFmhePNSm2APx+soP17T7QnM+txx538=
MIME-Version: 1.0
In-Reply-To: <200911231018.00163@fortytwo.ch>
References: <200911200823.58897@fortytwo.ch>
	 <cone.1258925270.277361.2967.1000@deskpiie>
	 <200911231018.00163@fortytwo.ch>
Date: Mon, 23 Nov 2009 11:58:54 +0200
X-Google-Sender-Auth: 1e0cde9fcec29351
Message-ID: <84144f020911230158lecd54c2xbf5380602c02c2fd@mail.gmail.com>
Subject: Re: acerhdf: stilll fighting between kernel and BIOS?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Adrian von Bidder <avbidder@fortytwo.ch>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 11:17 AM, Adrian von Bidder
<avbidder@fortytwo.ch> wrote:
> Heyho!
>
> On Sunday 22 November 2009 22.27:50 Peter Feuerer wrote:
>> issues with AOA 150 netbooks should be solved with current 2.6.32-git
>>  tree. You can also try to use latest acerhdf of http://piie.net
>
> Seems to work fine.  That was the fix I thought was already included in
> 2.6.31.

Is that commit ded0cdfc6a7673916b0878c32fa8ba566b4f8cdb ("acerhdf: fix
fan control for AOA150 model")? Should it go to -stable?
