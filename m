Return-Path: <linux-kernel-owner+w=401wt.eu-S968436AbXG3TNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968436AbXG3TNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968004AbXG3TN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:13:27 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:40110 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967853AbXG3TN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:13:26 -0400
Date: Mon, 30 Jul 2007 15:13:22 -0400
From: Adam Kropelin <akropel1@rochester.rr.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/3] 2.6.23-rc1: known regressions with patches v3
Message-ID: <20070730191322.GA24512@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE1304.80408@googlemail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Here is a list of some known regressions in 2.6.23-rc1
> with patches available.

I don't know which list this belongs in (good: 2.6.20.6, bad 2.6.22.1),
but here's a clear regression with patch:

Subject         : Edgeport UPS Monitoring Problems
References      : http://lkml.org/lkml/2007/7/27/334
Last known good : 2.6.20.6
Submitter       : Nick Pasich <NewsLetters@NickAndBarb.net>
Caused-By       : 
Handled-By      : Adam Kropelin <akropel1@rochester.rr.com>
Patch           : http://lkml.org/lkml/2007/7/29/164
Status          : patch available

--Adam

