Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbXHFWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbXHFWxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763827AbXHFWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:53:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:10385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763112AbXHFWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L/sar7werBGU0oi2jNduOHNLxekUYTpm2sH3imCyjTgKhQF5MALo4bQbIiudLerAAwImCRzjIgOvijZtNtKiUZaTob88XbngTBbi5Vk8UY/3tnN6Jk1f7RxMyzttABnlDqr+Pe19s0/ycAUTTLuBOWtV40hDh5UkDyIJ9CzfGs4=
Message-ID: <b6a2187b0708061553q69f23586r770ae037c8c84c8d@mail.gmail.com>
Date: Tue, 7 Aug 2007 06:53:14 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.23-rc2
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <46B75B79.3080604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
	 <1186317610.5220.3.camel@daplas>
	 <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
	 <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
	 <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
	 <39839.81.207.0.53.1186418772.squirrel@secure.samage.net>
	 <46B75784.5030502@zytor.com>
	 <59814.81.207.0.53.1186421522.squirrel@secure.samage.net>
	 <46B75B79.3080604@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Indan Zupancic wrote:
> >
> > I thought he was using a VGA console, wouldn't that be in text mode?
> >
>
> That is, exactly, the problem.  It should be, it's not.

The text-console is the VGA console right? I hope we're refering to
the same thing. It's the first boot-up screen I get without going into
X (startx). It's /dev/tty1.

Thanks,
Jeff.
