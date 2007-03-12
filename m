Return-Path: <linux-kernel-owner+w=401wt.eu-S965375AbXCLJHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbXCLJHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXCLJHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:07:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:43131 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965375AbXCLJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=syrNAbBpjL7y1bmFRy0+PiX+wmRmFgfna7FzFnkr9vpxOTDPynC/DnizFX8I6j5HYmAliK5NcSGbzwUM2pvpLhCS1GfBD373DgK0EzkXvNfEIlBOo4WbwOVroArOtXo2tpThRKj8rRVzWxu74uhfTlZvjiIDZ1Y5aI30G8JkDr8=
Message-ID: <38b2ab8a0703120207n3eff662fya883f46b1d3f1355@mail.gmail.com>
Date: Mon, 12 Mar 2007 10:07:34 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: jim@coolzero.info
Subject: Re: PCI failures during boot
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <36250.84.81.1.164.1173440523.squirrel@webmail.coolzero.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0703090331u10c6c66ck8e01f247fec975fe@mail.gmail.com>
	 <36250.84.81.1.164.1173440523.squirrel@webmail.coolzero.info>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3/9/07, Jim van Wel <jim@coolzero.info> wrote:
> Hi there,
>
> Please try first a newer kernel of FC6.
>
> 2.6.19-1.2911.6.5.fc6
>
> That's 2.6.19.7.
>
> That's the newest one.
>

I updated my kernel to 2.6.19-1.2911.6.5.fc6 and unfortunately it
doesn't help, I still have these errors.

I attached the new dmesg, if anybody can give me some hints that would be great.
-- 
Francis
