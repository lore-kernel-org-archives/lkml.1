Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXKZB2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXKZB2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbXKZB2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:28:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:2639 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXKZB2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YStfNFXd2qIvyaeGV2gZLR06maayrQJP3dJw39LnF2fgGinM/KRwqvrRZESiSrUJ5IrVUq2uLvmasUWlOuhGDutojVinyY8DhQINI4Ii5qjqA7vL/3mu10klfoX/njcy0ZLUC7FNheg7cuUgEYy/gh0adOGn6nsGLI9PCnmZI1A=
Message-ID: <fc94aae90711251728u4861d714r4363f9a5c40a4088@mail.gmail.com>
Date: Mon, 26 Nov 2007 01:28:36 +0000
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Frank Seidel" <fseidel@suse.de>
Subject: Re: [RFC] Re: nozomi version 2.1d for review
Cc: linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       greg@kroah.com, "Greg KH" <gregkh@suse.de>, p.hardwick@option.com,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <200711111743.30348.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711091449.24648.fseidel@suse.de>
	 <200711100027.04938.fseidel@suse.de>
	 <200711101652.56763.fseidel@suse.de>
	 <200711111743.30348.fseidel@suse.de>
X-Google-Sender-Auth: dc550f61d5086216
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank

I was wondering if you had a git tree somewhere I could pull.

Thanks

Mike

On 11/11/2007, Frank Seidel <fseidel@suse.de> wrote:
> Hello,
>
> this one also holds the - little reworked and optimized -
> cleanup of the read/write_mem32 functions.
>
> Comments and any feedback is more than welcome.
>
> Thanks a lot - especially to Jiri, Alan and Greg,
> Frank
