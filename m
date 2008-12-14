Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYLNPOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYLNPOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYLNPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:14:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:63933 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYLNPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=As2Rzcim/vv/lZqO241QddZai59b2uXpGwXiT0wGVF1Iwz8b3nmA9VOo1euKTOaEyz
         51CIrU5ze8R+qWFghoBu6ouFNCbT+TUtI8FD3mHkvWjUSDNoNPUWLrZW7DM+ddSo0vMq
         Kp7qaLVuqQlvAj1222ROeiydKcOqlW9yfXHUY=
Message-ID: <3f9a31f40812140714n7e58e0efgbe0f5bdc40214edf@mail.gmail.com>
Date: Sun, 14 Dec 2008 20:44:02 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: BUG - ath9k keep on disconnecting in 2.6.28-rc8
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       lrodriguez@atheros.com, jmalinen@atheros.com,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <18756.48950.20615.440764@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40812132354k6f9e7b80o30d3236687dffba0@mail.gmail.com>
	 <18756.48950.20615.440764@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sujith,

On Sun, Dec 14, 2008 at 1:39 PM, Sujith <m.sujith@gmail.com> wrote:
>
> A number of updates have gone into the wireless-testing tree.
> You can use that tree or compat-wireless to get the latest driver
> and check if the problem persists.
>

It seems wireless-testing tree fixed my ath9k problem, I am quite
happy with it :-)

I am still checking ath9k by using wireless-testing tree with
different ways and let you know If I face more problems.

Thanks for your help.

Jaswinder Singh.
