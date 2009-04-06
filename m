Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbZDFWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbZDFWWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbZDFWWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:22:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:4312 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723AbZDFWWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:22:07 -0400
Date: Tue, 7 Apr 2009 08:21:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
In-Reply-To: <200904062049.AFJ90113.JFOOSFOVQHLFMt@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.0904070821330.14814@tundra.namei.org>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <200903270412.n2R4CG7o054009@www262.sakura.ne.jp> <200904062049.AFJ90113.JFOOSFOVQHLFMt@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Tetsuo Handa wrote:

> Thanks.
> ----------
> Subject: tomoyo: remove "undelete domain" command.
> 
> Since TOMOYO's policy management tools does not use the "undelete domain"
> command, we decided to remove that command.
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
