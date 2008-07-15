Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYGOR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYGOR6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYGOR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:57:44 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:18694 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbYGOR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:57:42 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 19:57:36 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <200807151836.57983.elendil@planet.nl> <20080715103352.4a47419e@infradead.org>
In-Reply-To: <20080715103352.4a47419e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151957.37773.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 17:57:40.0412 (UTC) FILETIME=[46099FC0:01C8E6A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, Arjan van de Ven wrote:
> > The simple answer for my current use of dep-pkg is: I don't _have_
> > any hardware that requires firmware that's split out with current
> > kernels.
>
> ... and do you have any with current -git ?

Haven't tried that yet. Only just finished building .26 for my boxes and 
have other priorities ATM anyway.
You'll hear about it on the list when I do :-)
