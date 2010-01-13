Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140Ab0AMI3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0AMI3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117Ab0AMI3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:29:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056Ab0AMI3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:29:44 -0500
Date: Wed, 13 Jan 2010 00:29:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
Message-Id: <20100113002939.2d2c489d.akpm@linux-foundation.org>
In-Reply-To: <f17812d71001130023n491879cakc02dfcf26ec0fe43@mail.gmail.com>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
	<f17812d71001072128g63361e74q74cf06ae1e1eb3d6@mail.gmail.com>
	<20100112150952.aa224e20.akpm@linux-foundation.org>
	<f17812d71001121923k5a67c42flb92cf7bb2c8a0b5a@mail.gmail.com>
	<f17812d71001130023n491879cakc02dfcf26ec0fe43@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 16:23:35 +0800 Eric Miao <eric.y.miao@gmail.com> wrote:

> Attached is the patch against Documentation/gpio.txt

Thanks.

I was thinking kerneldoc in the .c file actually - most/all of the
other interface functions in gpiolib.c seem to be done that way.

