Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXCEULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXCEULZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXCEULZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:11:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:17969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXCEULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N+5DzeV4MSEHIDF+qPx3deiC9xNs+SGgdbCylVvq2+Kj1aO7x2mXYN3uGNkL3OU5S9RRlUWt37x+rSOEK4oquucelQ7IGhSkDsdhBGcWerrFLsbHI7p53trqcJo8UAG3NjU+7a2xeoN6TMGFXQglSHLlTj8oBAsMi70YHC0Ztlc=
Message-ID: <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
Date: Mon, 5 Mar 2007 15:11:18 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
Cc: "Li Yu" <raise.sail@gmail.com>, "Greg Kroah Hartman" <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harold Sargeant" <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
In-Reply-To: <1173127471.6638.96.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <1173127471.6638.96.camel@aeonflux.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> This also means that the current keyboard and mouse
> input devices will become a HID driver.
>

Are you talking about usbmouse and usbkbd?

-- 
Dmitry
