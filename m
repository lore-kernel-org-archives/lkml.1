Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbXERWUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbXERWUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXERWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:20:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:1770 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbXERWUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Wgo+3SDJi3ctOK3a1mHd9S3MsuFY0nPDNrcHVsBTygJ0m7zVC9yc3izjgjNYhnX6vfeDneuJ9snqbahZwRuPwnEPDXnT/nbTRGP3PqW0iIpsv+Kz90H8y4+gWHi4ANd45TYGIFOokkG6wrvjYWj0VCUx8wRSMtoait2ZjuW8Y+s=
Message-ID: <75b66ecd0705181520p5c306e6dm146ccb4792853acd@mail.gmail.com>
Date: Fri, 18 May 2007 18:20:42 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Tomas Carnecky" <tom@dbservice.com>
Subject: Re: SideWinder GameVoice driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <464C5FAC.8060609@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464C5FAC.8060609@dbservice.com>
X-Google-Sender-Auth: ed8137c14ec22219
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Tomas Carnecky <tom@dbservice.com> wrote:
> Despite it's a Microsoft product, it's actually very nice and useful. A
> little pad with a few buttons and connectors for a headset. It's an USB
> device, but it doesn't represent itself as an input/HID device:
>    HID device not claimed by input or hiddev

Is the audio part of the device USB audio class compliant?

Lee
