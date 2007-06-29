Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbXF2Wpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbXF2Wpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXF2Wpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:45:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXF2Wpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:45:30 -0400
Subject: Re: how to determine if the noexec stack is defined by an
	application
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <jebqeyfknd.fsf@sykes.suse.de>
References: <46856F24.5060407@andrei.myip.org>
	 <1183153758.2894.1.camel@laptopd505.fenrus.org>
	 <jefy4aflvs.fsf@sykes.suse.de>
	 <1183156068.2894.4.camel@laptopd505.fenrus.org>
	 <jebqeyfknd.fsf@sykes.suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 29 Jun 2007 15:43:38 -0700
Message-Id: <1183157018.2894.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 00:41 +0200, Andreas Schwab wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > (all others default to executable stack)
> 
> Except ia64.


for ia64 it depends on the personality actually .. just to make it more
complex.
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

