Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbYGPQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbYGPQqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYGPQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:46:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836AbYGPQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:46:34 -0400
Date: Wed, 16 Jul 2008 10:44:51 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/usb/class/usblp.c: adjust error handling code
Message-Id: <20080716104451.a4c6d06c.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0807161717220.28783@ask.diku.dk>
References: <Pine.LNX.4.64.0807161717220.28783@ask.diku.dk>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 17:17:42 +0200 (CEST), Julia Lawall <julia@diku.dk> wrote:

> In this code, it is possible to tell statically whether usblp will
> be NULL in the error handling code.

I think it's fine. Not much benefit IMHO.

-- Pete
