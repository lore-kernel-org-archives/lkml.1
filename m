Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYDCRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYDCRU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbYDCRUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:20:36 -0400
Received: from oss.sgi.com ([192.48.170.157]:55947 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761900AbYDCRUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:20:35 -0400
Date: Thu, 3 Apr 2008 13:18:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 01/22] Generic show_mem() implementation
Message-ID: <20080403121834.GA20437@linux-mips.org>
References: <12071688283927-git-send-email-hannes@saeurebad.de> <1207168839586-git-send-email-hannes@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207168839586-git-send-email-hannes@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:40:07PM +0200, Johannes Weiner wrote:

> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

And also Acked-By: Ralf Baechle <ralf@linux-mips.org>.

Btw, the MIPS part of your patch is not a plain switch from arch to generic
code as the patch comments seem to imply - the arch version was broken for
some configs ...

  Ralf
