Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXHFWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXHFWsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762567AbXHFWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:48:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2846 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbXHFWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qxk1xKv3p4/BaZlsO+dYWTzTQy/Onc++PlZOWSZ1k+eZYf+EyXlMfSielK10M0E97aHME0LVdmggmOv8p75Ay96jlZaVoKWYWejHY25rTlmn8BgzTmOv9hceWSdwS5lV+Scz9PgNx7YZcmSElJcX43dLo/P5JhNPHjUpWxE3kVc=
Message-ID: <b6a2187b0708061548m67bf776cte28315e2e5c84d40@mail.gmail.com>
Date: Tue, 7 Aug 2007 06:48:35 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: Linux 2.6.23-rc2
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <39839.81.207.0.53.1186418772.squirrel@secure.samage.net>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Indan Zupancic <indan@nul.nu> wrote:

> Does executing unicode_start, unicode_stop fixes it?

Doesn't seem to fix it. Now that I've to type blinding, I realised
that the text-console is about 1/20 of the whole screen size. If I
hold on to ENTER key, I could see the screen scroll. But sometimes,
the screen would just be blank and nothing shown. Whatever it is, I
could still type "startx" to go into X.

Thanks,
Jeff.
