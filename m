Return-Path: <linux-kernel-owner+w=401wt.eu-S969946AbXFHQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969946AbXFHQdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966574AbXFHQd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:33:26 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37493 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761035AbXFHQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:33:25 -0400
Date: Fri, 8 Jun 2007 12:33:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070608163302.GA9101@c2.user-mode-linux.org>
References: <20070531181923.GA9904@c2.user-mode-linux.org> <20070607232733.GM17082@mami.zabbo.net> <20070608161048.GA8147@c2.user-mode-linux.org> <CBFDCBBC-B5D8-4A91-9322-D63E107F38BF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CBFDCBBC-B5D8-4A91-9322-D63E107F38BF@oracle.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:26:01AM -0700, Zach Brown wrote:
> >I don't like it :-)
> 
> For a fundamental reason or because it happens to not work yet? :)

The latter - it fails the test that I posted.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
