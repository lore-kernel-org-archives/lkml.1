Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYFBOlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYFBOlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFBOkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:40:52 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52910 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYFBOkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:40:51 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Mon, 2 Jun 2008 16:40:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <200806021510.37992.oliver@neukum.org> <b6c5339f0806020706v5f48bc54tb2c17d0537d3ef5a@mail.gmail.com>
In-Reply-To: <b6c5339f0806020706v5f48bc54tb2c17d0537d3ef5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021640.43225.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 2. Juni 2008 16:06:51 schrieb Bob Copeland:
> Just curious, why is the reset quirk is needed since <= 2.6.25 worked fine?

I don't know. I suspect it is related to timing and you are just vastly
unlikelier to hit the issue under < 2.6.25.

	Regards
		Oliver

