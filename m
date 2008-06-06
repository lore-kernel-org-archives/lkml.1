Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbYFFRbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbYFFRbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYFFRa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:30:58 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:48077 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYFFRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:30:58 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Date: Fri, 6 Jun 2008 19:30:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200806051100.12885.dex@dragonslave.de> <20080606031718.36cbbdc9.akpm@linux-foundation.org>
In-Reply-To: <20080606031718.36cbbdc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061930.29046.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1212773457;e9358223;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-acpi)
>
> On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de> wrote:
> > Hi!
> >
> > (Added myself to CC, because I'm not subscribed)
> >
> > with linux-next snapshot 20080604 my Laptop morphes into sitting duck and
> > I think this is due to this:
>
> I assume 2.6.26-rc5 is OK?
Indeed.. just tried it with (nearly) the same config: no unable to locate 
IOAPIC

Will try todays next snapshot above -rc5 now.

BTW: Any chance to get this damn thing to not route everything by IRQ 11 !?

Greetings
Daniel Exner
