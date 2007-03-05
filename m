Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXCEW6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXCEW6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXCEW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:58:33 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23937 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXCEW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:58:32 -0500
Message-ID: <45ECA092.8080605@tls.msk.ru>
Date: Tue, 06 Mar 2007 01:58:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christopher.Prest@rogers.com
CC: linux-kernel@vger.kernel.org
Subject: Re: (trivia) remove useless typecast around `jif' variable
References: <20070305161251.AE2C97FAA@paltus.tls.msk.ru> <663650480-1173118082-cardhu_blackberry.rim.net-718749525-@bxe041-cell01.bisx.prod.on.blackberry>
In-Reply-To: <663650480-1173118082-cardhu_blackberry.rim.net-718749525-@bxe041-cell01.bisx.prod.on.blackberry>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher.Prest@rogers.com wrote:
> Yes sounds correct.  How many other places are being casted as well?

Care to find them? :)

This one took my attention by a chance.  I looked at various other files,
at least in fs/proc/, but don't see any other places like this.

/mjt
