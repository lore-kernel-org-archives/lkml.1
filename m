Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZGIMu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZGIMu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbZGIMuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:50:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11111 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349AbZGIMuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xRX7yWVD+ZKqkx/uuZe6f62Qds1hsEAWZxeEv0YxD/uzTR04Zf/PQ8dKvvGQK7WJvq
         4ZKceQmJy2HOESgnuOEsgZu4ZXWuVwWcoZaNywru4ooZlP2wWfNfHOcfIPFo5OsygQBC
         l3JmOvcv/BTp6Px6jyZNBMQfWRkpjw2c1pKpM=
MIME-Version: 1.0
In-Reply-To: <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
References: <4A54FB81.30302@gmail.com> <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com> 
	<4A551B43.3020104@gmail.com> <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com> 
	<4A5575C1.8090403@lwfinger.net> <3ace41890907090347m1f337731rb09b90327664ed5@mail.gmail.com> 
	<4A55D123.5090802@gmail.com> <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 9 Jul 2009 14:49:54 +0200
Message-ID: <69e28c910907090549q542691fan6756ebf9edac45a9@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9 Hin-Tak Leung <hintak.leung@gmail.com>:
> Here is some info from Gabor (shouldn't this be reply-all rather than just me):
> ------------------
> The v1 and v2 look identical (though the label on the device indicates
> the revision). The v3 looks completely different. They all have
> different USB IDs (v1 is stock RT73, v2 has a custom ID, while v3 is
> AFAIK stock RT2070).
> ------------------
>
> I guess to be informative, may I suggest adding '(for v1  see rt73usb,
> and v3 see rt3070)' or something similiar to the 'v2' change?
> It is fair customary in Kconfig to mention even alternative/competing
> drivers for the same device. And when you add v3 support to the rt3070
> driver, a reverse mention may be appropriate. (I guess I am spending
> far too long on this discussion - but I reckon, the purpose of a
> non-code-changing change is meant to be informative, so one might want
> to be as informative as appropriate without being too wordy...)
>

Yes, sorry, it was intended to be reply-to-all, but Gmail's
default-reply-to-all feature appears to be broken.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
