Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZLIOHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZLIOHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZLIOHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:07:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1032 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZLIOHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:07:41 -0500
Subject: Re: pass upstream rev to scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20091209090639.GA23236@pengutronix.de>
References: <20091209090639.GA23236@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 06:07:47 -0800
Message-ID: <1260367667.27319.11.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 10:06 +0100, Uwe Kleine-König wrote:
> I often face the "problem" that get_maintainer.pl yields my name, too,
> as the commits I want to send are included in HEAD.

Why is this a problem?

If you are using git send-email, does adding
--suppress-cc=self solve it?

