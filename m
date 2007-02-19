Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbXBSNmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbXBSNmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbXBSNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:42:09 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:39932 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbXBSNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:42:08 -0500
Subject: Re: unexpected continuation frame (len0)
From: Marcel Holtmann <marcel@holtmann.org>
To: Yuriy Vikulov <vikulov@rscenter.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070219T134438-844@post.gmane.org>
References: <loom.20070219T134438-844@post.gmane.org>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 14:42:30 +0100
Message-Id: <1171892550.26567.16.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuiry,

> i'm using: bluez-* 3.9
> kernel: 2.6.16
> 
> is error "unexpected continuation frame (len0)" is kind of bug?
> or may be "bad" bluetooth adapters?
> or i have missed something in my code?

it is likely a bad adapter. What Bluetooth hardware are you using?

Regards

Marcel


