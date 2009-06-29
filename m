Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbZF2NHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbZF2NHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2NHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:07:33 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47127 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF2NHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:07:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Mon, 29 Jun 2009 15:07:44 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru> <200906282258.08277.oliver@neukum.org> <200906291543.52477.ars3n@yandex.ru>
In-Reply-To: <200906291543.52477.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291507.45281.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Juni 2009 13:43:45 schrieb Arseniy Lartsev:
> Just the same with 2.6.31-rc1-git3.
>
> Any ideas?

Please printk xfertype in the error case of usb_submit_urb()

	Regards
		Oliver

