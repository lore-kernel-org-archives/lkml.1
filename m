Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbYGOAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbYGOAA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbYGOAAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:00:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:46526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbYGOAAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:00:00 -0400
Date: Mon, 14 Jul 2008 16:59:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080714165956.7fe2d4ee@infradead.org>
In-Reply-To: <20080714164119.99c33d5b.akpm@linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 16:41:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008 16:23:26 -0700
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Linus, please pull from the for-2.6.27 branch of:
> > 	git://git.infradead.org/users/dwmw2/firmware-2.6.git
> > for-2.6.27
> 
> The firmware flamewars seem to have subsided lately.  Is everyone
> happy with this now?
> 

this seems to have left the contentious pieces out....


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
