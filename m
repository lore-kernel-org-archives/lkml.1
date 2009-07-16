Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbZGPWEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbZGPWEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbZGPWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:04:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:59464 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbZGPWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:04:14 -0400
Date: Fri, 17 Jul 2009 08:04:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Sten Spans <Sten_Spans@genua.de>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: security_file_lock cmd argument
In-Reply-To: <20090716074139.GB23769@false>
Message-ID: <alpine.LRH.2.00.0907170803570.4170@tundra.namei.org>
References: <alpine.LRH.2.00.0907092031020.4944@tundra.namei.org> <alpine.LRH.2.00.0907161003550.27259@tundra.namei.org> <20090716074139.GB23769@false>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Sten Spans wrote:

> On Thu, Jul 16, 2009 at 10:05:47AM +1000, James Morris wrote:
> > > From: Sten Spans <Sten_Spans@genua.de>
> > 
> > This looks good, but you need to add a signed-off-by line per 
> > Documentation/SubmittingPatches
> > 
> 
> Makes sense, how about:
> 
> Pass posix-translated lock operations to security_file_lock
> when invoked via sys_flock.
> 
> Signed-off-by: Sten Spans <Sten_Spans@genua.de>

Thanks.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
