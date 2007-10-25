Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXJYU3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXJYU3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXJYU2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:28:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbXJYU2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:28:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.24-rc1 regression] suspend fails
Date: Thu, 25 Oct 2007 22:44:50 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200710252147.22814.arvidjaar@mail.ru>
In-Reply-To: <200710252147.22814.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252244.50711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 October 2007 19:47, Andrey Borzenkov wrote:
> I can no more suspend with 2.6.24-rc1. 2.6.23 is fine. Here is kernel log; 
> config attached

Please try the patch from:
http://marc.info/?l=linux-mm-commits&m=119318609013090&w=2

Greetings,
Rafael


