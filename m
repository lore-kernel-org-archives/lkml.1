Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYHYHbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYHYHbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHYHbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:31:32 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:41090 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYHYHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:31:32 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: converting appletouch to usb autosuspend again...
Date: Mon, 25 Aug 2008 09:32:38 +0200
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <dd18b0c30808242122h5b6dfc15tf86622595bd46461@mail.gmail.com> <200808250840.06477.oliver@neukum.org> <dd18b0c30808250008t342fad9fr1a54a0662473a38@mail.gmail.com>
In-Reply-To: <dd18b0c30808250008t342fad9fr1a54a0662473a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808250932.39133.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 August 2008 09:08:49 schrieb Justin Mattock:
> Alright; as for the appletouch
> not working upon wakeup, I just tried it to see,
> and it is working...(can't explain why it wasn't, maybe a quirk somwhere);
> Although; I am receiving an error, so maybe this has something to
> do with it(heres the thread):
> http://marc.info/?l=linux-kernel&m=121926203029380&q=raw

That's bluetooth. Totally unrelated.

So to summarize: suspend/resume has been tested and works.
What about autosuspend? Did you test that?

	Regards
		Oliver

