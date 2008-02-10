Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYBJGwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYBJGwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYBJGvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:51:55 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:37305
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbYBJGvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:51:54 -0500
X-Trace: 37644739/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFcurkdTQwss/2dsb2JhbACneA
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: One minute delay when booting 2.6.24.1
Date: Sun, 10 Feb 2008 06:51:53 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802091329.35851.tvrtko@ursulin.net> <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802100651.53142.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008 22:01:44 Jan Engelhardt wrote:
> On Feb 9 2008 13:29, Tvrtko A. Ursulin wrote:
> >Hi all,
> >
> >As the subject says I get ~1 minute delay when booting 2.6.24.1
> >pretty reliably. It is possible it is not new to 2.6.24.1 but I
> >can't tell due recent hardware changes.
> >
> >dmesg excerpt where it happens looks like this (full one attached):
>
> Do you really experience a 1 minute wait, or is this perhaps
> just the clock skipping?

It is a real delay.

Tvrtko
