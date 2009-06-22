Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZFVGcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZFVGcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZFVGcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:32:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39900 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZFVGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:32:47 -0400
Subject: Re: staging: w35und: fix compilation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090619222241.GA2304@elf.ucw.cz>
References: <20090619222241.GA2304@elf.ucw.cz>
Date: Mon, 22 Jun 2009 09:32:48 +0300
Message-Id: <1245652368.18751.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 00:22 +0200, Pavel Machek wrote:
> config_interface was removed in 2.6.30, remove it from w35und, too, to
> fix compilation.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

