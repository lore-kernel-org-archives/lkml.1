Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYGNXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYGNXmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbYGNXmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:42:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616AbYGNXmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:42:02 -0400
Date: Mon, 14 Jul 2008 16:41:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-Id: <20080714164119.99c33d5b.akpm@linux-foundation.org>
In-Reply-To: <1216077806.27455.85.camel@shinybook.infradead.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 16:23:26 -0700
David Woodhouse <dwmw2@infradead.org> wrote:

> Linus, please pull from the for-2.6.27 branch of:
> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27

The firmware flamewars seem to have subsided lately.  Is everyone happy
with this now?

