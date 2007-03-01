Return-Path: <linux-kernel-owner+w=401wt.eu-S965466AbXCASMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965466AbXCASMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXCASMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:12:23 -0500
Received: from iona.labri.fr ([147.210.8.143]:57432 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965466AbXCASMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:12:22 -0500
Date: Thu, 1 Mar 2007 19:11:57 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: differences between MADV_FREE and MADV_DONTNEED
Message-ID: <20070301181157.GG3550@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ek36r9vq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Eric wrote:
> > We should implement a real MADV_DONTNEED and rename the current one
> > to MADV_FREE, but that's 2.6.17 material.
> 
> We definitely need to check this.  I am fairly certain I have seen
> this conversation before.

Yes, it was back in 2005:
http://marc.theaimsgroup.com/?l=linux-kernel&m=111996850004771&w=2

Nobody took the time to fix it, I filed bug #6282 on bugzilla.kernel.org
some time ago.

Samuel
