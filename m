Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZC0Nfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZC0Nfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZC0Nfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:35:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZC0Nfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:35:30 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 14:35:22 +0100
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903271435.23116.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18KEuk0ls+40vmFTxFvhkD8QmxNdvgEFRV6oNx
 gJ/QLNN1Nrr3khWB5X0nz1Ro6WRg4PuV7a/8QQtx6NeeS1wutQ
 FgUGd5DnS1/l9r1k7bO0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 24. März 2009 schrieb Linus Torvalds:
>
> This obviously starts the merge window for 2.6.30, although as usual,
> I'll probably wait a day or two before I start actively merging.

It would be very nice, if you could start with a commit to Makefile, that 
reflects the new series: e.g.:

VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 30
EXTRAVERSION = -pre

-pre for preparing state.

Thanks,
Pete
