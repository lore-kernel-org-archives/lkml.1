Return-Path: <linux-kernel-owner+w=401wt.eu-S933914AbZINUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbZINUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbZINUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:34:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56434 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbZINUeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:34:08 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Mon, 14 Sep 2009 22:35:31 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200909142015.56698.volkerarmin@googlemail.com>
In-Reply-To: <200909142015.56698.volkerarmin@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909142235.32752.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. September 2009 20:15:56 schrieb Volker Armin Hemmann:
> I turned off
> USB selective suspend/resume and wakeup
>
> and turned on
> Root Hub Transaction Translators
>  Improved Transaction Translator scheduling
>
> and haven't had any lockup anymore.
>
> Sorry for the noise. Really.

Can you please find out whether all the options you found are needed?

	Regards
		Oliver

