Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYFBQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYFBQeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFBQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:34:16 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:60215 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752665AbYFBQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:34:16 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Add workaround for bug in ASUS A7V600 BIOS (rev 1005)
Date: Mon, 2 Jun 2008 09:34:04 -0700
User-Agent: KMail/1.9.9
Cc: Bertram Felgenhauer <int-e@gmx.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080530012005.GA9514@zombie.inf.tu-dresden.de> <20080531155805.GA17465@elte.hu>
In-Reply-To: <20080531155805.GA17465@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806020934.04488.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 31, 2008 8:58 am Ingo Molnar wrote:
> * Bertram Felgenhauer <int-e@gmx.de> wrote:
> > This BIOS claims the VIA 8237 south bridge to be compatible with VIA 586,
> > which it is not.
> >
> > Signed-off-by: Bertram Felgenhauer <int-e@gmx.de>
>
> Cc:s added.

I didn't see the original report, pulling down the for-jesse stuff to look 
through it now though.

Jesse
