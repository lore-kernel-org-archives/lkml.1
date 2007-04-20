Return-Path: <linux-kernel-owner+w=401wt.eu-S1767146AbXDTQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767146AbXDTQBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767154AbXDTQBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:01:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:64150 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767149AbXDTQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GSr6dyCTpxXrNeaZsCe35NWQojSMMjAD7wkgUmBR+rUPl26m5MsiyA/+nK5jE5LqEbYJBoslHh95j0y7pNtMytaso6DppY/TwBUNcKLifIqL1bOtGkW8AXwKCBhivbUW2PPWnSIC6LGBUuklgeT5k962wqifMrFS9NAcdD7tKr4=
Message-ID: <d120d5000704200901m44c9a3aei9ee0572c3b0a61ab@mail.gmail.com>
Date: Fri, 20 Apr 2007 12:01:41 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       edouard.tisserant@wanadoo.fr, vojtech@ucw.cz
In-Reply-To: <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
	 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
	 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
	 <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
	 <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
>
> Sorry, it seems I was wrong, it's not usbhid but usbmouse taking over.
> After a fresh plug (e.g. at bootup) I get the following:
>

Well, the question is - why do you have usbmouse module on your system?

-- 
Dmitry
