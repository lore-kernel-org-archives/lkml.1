Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXKQQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXKQQHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXKQQHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:07:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:1626 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXKQQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gFkjwwX121QuE48fJV6zvuStnoTaYCQVU8Qzu3rlkn4P4x2ayDHf7gBFpiHpdWTAPEhYj4y0i+lNNKmUJLqij7Ydr4a7C2imMlQvyAhElevD6wzK4uzNogVKtmpbkXg/IADoFby/scK7VbqcpUbBjxRuRzjNQInNbkFCCURUzSg=
Message-ID: <a278970e0711170807u1e2a15a7q4d42b5adcba3ea91@mail.gmail.com>
Date: Sat, 17 Nov 2007 17:07:30 +0100
From: "Luca Tiburzio" <luca.tiburzio@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: sitecom wl162
In-Reply-To: <a278970e0711170803v271a2987l1da9478bebd8c66e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a278970e0711170803v271a2987l1da9478bebd8c66e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to wireless usb key sitecom wl162

in ./drivers/net/wireless/zd1211rw/zd_usb.c
added srtuct { USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },

I've to do it by myself every time i update kernel. Please add it.

Thank you
