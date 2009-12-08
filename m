Return-Path: <linux-kernel-owner+w=401wt.eu-S965843AbZLHVnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965843AbZLHVnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966200AbZLHVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:43:18 -0500
Received: from 1wt.eu ([62.212.114.60]:52628 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966449AbZLHVnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:43:18 -0500
Date: Tue, 8 Dec 2009 22:43:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, matti.aarnio@zmailer.org,
       mgalgoci@redhat.com
Subject: Re: Vger outage on Dec 12th and 13th
Message-ID: <20091208214303.GB32739@1wt.eu>
References: <20091208.015956.200531033.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208.015956.200531033.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Dec 08, 2009 at 01:59:56AM -0800, David Miller wrote:
> 
> In order to move vger.kernel.org from one co-location facility
> to another, there will be a downtime on Dec 12th and 13th.
> 
> The IP address will change but the hostname will stay the same
> of course.

would you happen to already know in advance its new IP address ?
Some people (me included) white-list it so that incoming mails
do not experience any form of filtering. In my case, I do that
so that vger does not suffer from any SMTP HELO delay. Setting
that in advance will make the migration smoother for everyone.

> Sorry for any inconvenience this may cause.

you don't have to be sorry, we'd better thank you for taking care
of the beast :-)

Cheers,
Willy

