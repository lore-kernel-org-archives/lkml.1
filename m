Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZF1Ru4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZF1Ru4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZF1Rut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:50:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44071 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753593AbZF1Rus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:50:48 -0400
Date: Sun, 28 Jun 2009 18:51:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Digi International, Inc" <Eng.Linux@digi.com>
Subject: Re: [PATCH 14/62] drivers/char/epca.c: Remove unnecessary
 semicolons
Message-ID: <20090628185102.47663e61@lxorguk.ukuu.org.uk>
In-Reply-To: <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	<1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 09:26:19 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/char/epca.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

If you must do this then please roll it into a single patch and get it
applied so it doesn't mess up all the pending patches. Really though I
have to ask what the point is - it just makes other patches not apply and
creates noise work.
