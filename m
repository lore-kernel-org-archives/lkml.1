Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbXHAWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbXHAWbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXHAWbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:31:08 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:10688 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXHAWbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:31:07 -0400
Date: Thu, 2 Aug 2007 00:31:00 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: More documentation: system call how-to
Message-ID: <20070801223100.GB9010@osiris.ibm.com>
References: <200708011806.l71I6v9N002535@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011806.l71I6v9N002535@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 02:06:57PM -0400, Ulrich Drepper wrote:

> I've added a few rules I could think of right now.  What should be
> added as well is a rule for 64-bit parameters on 32-bit platforms.  I
> leave this to the s390 people who have the biggest restrictions when
> it comes to this.

David Woodhouse wrote that already. Don't know if there is a patch
pending: http://marc.info/?l=linux-arch&m=118277150812137&w=2
