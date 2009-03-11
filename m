Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZCKRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZCKRcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZCKRcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:32:00 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:35595 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZCKRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:32:00 -0400
Date: Wed, 11 Mar 2009 18:31:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/18] mips: convert obsolete irq_desc_t to struct
	irq_desc
Message-ID: <20090311173123.GB30006@linux-mips.org>
References: <20090311003204.592133594@linutronix.de> <20090311003236.133903965@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311003236.133903965@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:45:51AM -0000, Thomas Gleixner wrote:

Thanks, queued for 2.6.30.

  Ralf
