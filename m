Return-Path: <linux-kernel-owner+w=401wt.eu-S938797AbZDJRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938797AbZDJRHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937952AbZDJRHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:07:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33072 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937579AbZDJRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:06:59 -0400
Date: Fri, 10 Apr 2009 19:10:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
Message-ID: <20090410171001.GA26156@elf.ucw.cz>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp> <20090408133524.395437925@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408133524.395437925@I-love.SAKURA.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-08 22:31:27, Tetsuo Handa wrote:
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>

Could we get an user<->kernel interface documentation?

> +--- How to enable TOMOYO? ---
> +
> +Build the kernel with CONFIG_SECURITY_TOMOYO=y and pass "security=tomoyo" to
> +kernel's command line.

"on kernel's" ?

> +--- Where are documentations? ---

"Where is documentation?"

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
