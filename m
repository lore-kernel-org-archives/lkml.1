Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXJ2T1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXJ2T1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXJ2T1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:27:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27269 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbXJ2T1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=pvOSl3aaCMzr7imqwuRaJDuJt+FlPsWqGKk8wFDeXRmjMS7Y76AlE5cNHMed9vIx1QfkMioKvdtPQiC17eJimZqNoBW7O6bNmtldFwGUQ+Q1IBlgClnA/C0PN0BkVwwn7yxVFslbzdkGAN2+zvUP3N6WOeo7XV7R+CRUkIrikFY=
Message-ID: <6101e8c40710291227t6b705eaaw7b7be7147c976e57@mail.gmail.com>
Date: Mon, 29 Oct 2007 20:27:08 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [REGRESSION 2.6.22.Y] KEYBOARD && CAPSLOCK && RANDOM UPPER and LOWERCASE CHARs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000710290607x66832f96lad21d37fff987b09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9661_32098295.1193686029003"
References: <6101e8c40710281850s2d9ca5ads6859ed692c21bc51@mail.gmail.com>
	 <d120d5000710290607x66832f96lad21d37fff987b09@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9661_32098295.1193686029003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!

under 2.6.21.7 is too reproductable ..

I have hungarian keybord (PS/2) and the locales sets, to en_EN

LANG=3Den_US
LC_CTYPE=3D"en_US"
LC_NUMERIC=3D"en_US"
LC_TIME=3D"en_US"
LC_COLLATE=3D"en_US"
LC_MONETARY=3D"en_US"
LC_MESSAGES=3D"en_US"
LC_PAPER=3D"en_US"
LC_NAME=3D"en_US"
LC_ADDRESS=3D"en_US"
LC_TELEPHONE=3D"en_US"
LC_MEASUREMENT=3D"en_US"
LC_IDENTIFICATION=3D"en_US"
LC_ALL=3D


On 10/29/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Oliv=E9r,
>
> On 10/28/07, Oliv=E9r Pint=E9r <oliver.pntr@gmail.com> wrote:
> > Hi Dmitry!
> >
> > I have one very nice regression ... under 2.6.22 kernel, im VT mode,
> > when I turn on the caps lock and I typing for Q - M, then become this
> > string: qwERTZUiOP=F5=FAAsdfgHjkl=E9=E1=FB=EDyxcvbnM
> >
> > i tested under 2.6.22.9 tainted, 2.6.22.9 not tainted, 2.6.22.10
> > tainted and 2.6.22.10 not tainted. Under FreeBSD is all ok, and under
> > X is ok. All kernell tested under debian 3.1 Sarge and 4.0 Etch.
> >
>
> I presume 2.6.21 works for you? Could you tell me what keymap you are
> loading?
>
> --
> Dmitry
>


--=20
Thanks,
Oliver

------=_Part_9661_32098295.1193686029003
Content-Type: application/x-gzip; name=boottime.kmap.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=boottime.kmap.gz

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
plSIUypkUSokUyrEKRWyKBWSKRXilApZlArJlApxSoUsSoVkSoU4pSIWpSIypSKcUhGLUhGZUhFO
qYhFqYhMqQinVMSiVESmVIRTKmJRKiJTKsIpFbEoFZEpFeGUiliUisiUinBKRSxKRWRKRTilIhal
IjKlIpxSEYtSEZlSEU6pmEWpmEypGKdUzKJUTKZUjFMqZlEqJlMqxikVsygVkykV45SKWZSKyZSK
cUrFLErFZErFOKViFqViMqVinFIxi1IxmVIxTqmYRamYTKkYp1TMolRMplSMUyphUSohUyrBKZWw
KJWQKZXglEpYlErIlEpwSiUsSiVkSiU4pRIWpRIypRKcUgmLUgmZUglOqYRFqYRMqQSnVMKiVEKm
VIJTKmFRKiFTKsEplbAolZAplaCUggmHUk02RXYkUzd7LFmPLOvhssCSBbIs4LI+S9Yny/q4rGDJ
CrKswGUDlmxAlg1w2ZAlG5JlQ1w2YslGZNkIl41ZsjFZNsZlE5ZsQpbFKeWxKOWRKeXhlPJYlPLI
lPJwSnksSpFrWwGvbQWPRSlybSvgta3gsShFrm0FvLYVPBalyLWtgNe2gseiFLm2FfDaVvBYlCLX
tgJe2woei1Lk2lbAa1vBY1HKI1PKwykFLEoBmVKAUwpYlAIypQCnFLAoBWRKAU4pYFEKyJQCnFLA
ohSQKQU4pYBFKSBTCnBKAYtSQKYU4JQCFqWATCnAKcWqPQdy7TngtefAqj0Hcu054LXnwKo9B3Lt
OeC158CqPQdy7TngtefAqj0Hcu054LXnwKo9B3LtOeC158CqPQdy7TngtefAqj0Hcu054LXnwKo9
B3LtOeC158CqPQdy7TngtefAqj0Hcu054LXnwKo9B3LtOeC158CqPQdy7TngtefAqj0Hcu054LXn
wKo9B3LtOeC158CqPQdy7TngtefAqj0Hcu054LXnwKo9B3LtOeC158CqPQdy7TngtefAqj0Hcu05
4LXnwKo9B3LtOeC158CqPQdy7TngtefAqj0Hcu054LXnwKo9B3LtOeC158CqPQdy7TngtefAqj0H
cu054LXnwKo9B3LtOeC158CqPQdy7flI5npT5qtT+WuML+xdf3Pi+2+8cXBdRUFHb+qor6O3dFTo
6G0dDXT0jo6GKupF7+hwpMOxEY51ODHCiQrDxAjXr3TbuGfG9RDBN+N6kCDMuB4mBGZcDxRCM66H
CqZ7Tw8WTPueHq3f86mH64MZ1+P1Tf+gx+ub/uVPbKh50/H2pxyUJd3S/oqD6ky3tL9A0bUYKs3P
bHQNxjTVPzvRxY1pan6xoWu4rzuq/0f0Lv7w+nOzYnlRVKH9D+zv7R/s722Kvf0P7vfDaRP+gRF+
c1+nf8iOt/k/NOLv1+kftsJt9o+M8Ds6+yNWuM3+sRG+rrM/aoXb7J8Y4Qc6+2NGuNDZPzXCE3f2
xJ194M5Ox7PvNOGPW9lZE/6ZEb5RhW814U9Y4VkT/rl12dq+P2mF275/YV+1Nv1TdrzN/6V12dr0
T1vhNvtX1oVosz9jhdvsX1sW7zbhz1rhvAn/xnbYpn/Ojrf5v7Ustumft8Jt9u8si232F6xwm/17
I/x8Fb7dhL9ohedN+A/WYn6lCX/JCq+a8B+t4T9owl+2wkUT/pM9+jb9K3a8zf+zNfw2/atWuM3+
i2Wxzf6aFW6z/2pNVpv9dSvcZv/NCL9LZ3/DCrfZf7eG/7gJf9MKb5vwP+zRt+nfsuNt/j+t4bfp
37bCbfa/rAG12d+xwm32v23N15v4d+34VRP/jxF/tQq/1IS/Z4Q3VfisCf/XCK/36/9k+PuWl7bv
/1nZbw+zqxW+/5bK/j+6n1KJLXIAAA==
------=_Part_9661_32098295.1193686029003--
