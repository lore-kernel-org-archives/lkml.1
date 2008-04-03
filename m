Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYDCIyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYDCIyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDCIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:54:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:55887 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYDCIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XnxM3vdLFSac1cmwL465DhS8JrFxSTuL9km0NP18Ict+FUJVxS1dUkiaRHZ9WSsuxb+bIObBvTd/bflBTrHdiYUDh5Y0vcPWOk3Zbhf+MQdVLAQW5HH0nm04yFwJ/B9eBFKD4/yW7geBm3cDKrY5CQbKqOskwdlZ56QMjJBoJjI=
Message-ID: <e79639220804030153q46fa82c7jb79bedbe88b30df7@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:53:53 +0200
From: "Stefan Schweizer" <genstef@gentoo.org>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: suspend
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200804031029.26635.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804030932.27993.oliver@neukum.org> <ft21pb$oc3$1@ger.gmane.org>
	 <200804031029.26635.oliver@neukum.org>
X-Google-Sender-Auth: 7a200ac1bb8cdc3c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  On second thought, this should be fixed by usb persist if the appletouch
>  driver supported reset_resume. Would you be willing to test a kernel patch
>  that implements reset_resume in the appletouch driver?

Sure, I would love to have this fixed :-)

best regards,
-Stefan
