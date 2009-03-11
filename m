Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZCKI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZCKI0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZCKI0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:26:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40480 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751218AbZCKI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:26:34 -0400
Date: Wed, 11 Mar 2009 08:27:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: n0diamond@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Message-ID: <20090311082725.37cb1883@lxorguk.ukuu.org.uk>
In-Reply-To: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp>
References: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 10:50:39 +0900 (JST)
Norman Diamond <n0diamond@yahoo.co.jp> wrote:

> It looks like both LIBATA and the old IDE drivers have an
> off-by-one error in deciding whether to use READ SECTOR(S)
> instead of READ SECTOR(S) EXT.

This was fixed some time ago, you need a newer kernel.
