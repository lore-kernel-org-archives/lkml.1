Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYE3NzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYE3NzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYE3NzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:55:15 -0400
Received: from ozlabs.org ([203.10.76.45]:55462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYE3NzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:55:14 -0400
Date: Fri, 30 May 2008 15:54:06 +0200
From: Hugh Blemings <hugh@blemings.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, hugh@misc.nu, greg@kroah.com
Subject: Re: [PATCH] keyspan: use request_firmware()
Message-Id: <20080530155406.b0f2a505.hugh@blemings.org>
In-Reply-To: <1212147933.7948.8.camel@shinybook.infradead.org>
References: <1211708969@pmac.infradead.org>
	<1212147933.7948.8.camel@shinybook.infradead.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 14:45:33 +0300
David Woodhouse <dwmw2@infradead.org> wrote:

[...]

ACK

Seems reasonable to me, though I wouldn't claim to be particularly authoritative on such matters these days :)

Cheers,
Hugh
