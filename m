Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0CNUaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:30:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43727 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0CNUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:30:15 -0400
Subject: Re: 2.6.34-rc1: bluetooth oops
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <20100314201434.GE22059@elf.ucw.cz>
References: <20100314201434.GE22059@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 13:28:20 -0700
Message-ID: <1268598500.3897.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> I got this after trying to use bnep for few minutes... Machine locked
> after that, not sure if it is related.

I can't explain it since we haven't changed the BNEP code. So that might
be a problem in the networking layer. So posting it to netdev might be a
good idea.

Regards

Marcel


