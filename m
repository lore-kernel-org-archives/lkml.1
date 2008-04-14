Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYDNJDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYDNJDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYDNJDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:03:17 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:49449 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYDNJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KNKk+XGfsw45V0nf29ryifY1SneILXs5G7RBAuvvvCDy11q2PENAiDWiLzI3kof5impxUrGQz0465ZNouQVTAelzhDute2U9/l9DNffDHaGiGzeHLZr+MAiXbRaN6c2RJSeMoWO1YYk4XgiS86eHxBxY4pUVfY+oOVWUUpKbpA8=
Message-ID: <5699f8f00804140203t6f22d25dp7bd5a0d26203dd1f@mail.gmail.com>
Date: Mon, 14 Apr 2008 11:03:14 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Alexia Death" <alexiadeath@gmail.com>
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <002401c89df5$f5dd2b80$087811ac@encnet.ead.ems>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804132326.07713.alexiadeath@gmail.com>
	 <200804140245.33171.arnd@arndb.de>
	 <002401c89df5$f5dd2b80$087811ac@encnet.ead.ems>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 8:08 AM, Alexia Death <alexiadeath@gmail.com> wrote:
> It seems  this issue is a "wont fix" even tho its quite common since its a
>  reader problem.

There are a *LOT* of cardreaders that have a problem with larger cards.
See the table on http://www.hjreggel.net/cardspeed/special-sd.html and
notice the enormous amount of red colored cells (meaning failure)

Read the rest of http://www.hjreggel.net/cardspeed/ for a lot more
info about cards and card readers.

Wander.
