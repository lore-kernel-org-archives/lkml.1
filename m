Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYIDPFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYIDPFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYIDPFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:05:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:13844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIDPFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=a/rW/ktrfi7cjL2qXCgtkCoHaj3yA2vb4ZyFipETgIIkSLyKxo0pLSPA8UGpSWfRPJ
         pOjHVpnmkJhbGb5ul53uHoP2W/5NN0Ccd1CPQmHzQYx71Q+y7NFXM3NW3T5dSz4e3xdY
         ZnU5azykubud0ppuKGNzk0dVmZ2ceid9HXhho=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: [PATCH] ncurses based config
Date: Thu, 4 Sep 2008 17:02:30 +0200
User-Agent: KMail/1.9.9
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Nir Tzachar <nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> <Pine.LNX.4.64.0809031259110.20541@shark.he.net> <20080903222927.7d191458@Varda>
In-Reply-To: <20080903222927.7d191458@Varda>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809041702.30301.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008, Alejandro Riveira Fernández wrote:

[...]

> > I'm seeing cyan (?) foreground on black background.  Is that the colors
> > that were planned?
>   
>  much nicer colors here (ubuntu) 
>  http://img177.imageshack.us/my.php?image=pantallazonm7.png

Update: under Fedora9 with default settings:

- X + xterm: colors are OK

- X + konsole: colors are not OK

- console (on vesafb): colors are OK except that frames are "invisible"

Seems like there are some compatibility issues to be resolved...

Thanks,
Bart
