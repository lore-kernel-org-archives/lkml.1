Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZL0MpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZL0MpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZL0MpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:45:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45679 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZL0MpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:45:09 -0500
Date: Sun, 27 Dec 2009 13:45:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: michael@laptop.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, andi@firstfloor.org,
       david@lang.hm, socketcan@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       herbert@gondor.apana.org.au, Valdis.Kletnieks@vt.edu, bdonlan@gmail.com,
       zbr@ioremap.net, cscott@cscott.net, jmorris@namei.org,
       ebiederm@xmission.com, bernie@codewiz.org, mrs@mythic-beasts.com,
       randy.dunlap@oracle.com, xiyou.wangcong@gmail.com, sam@synack.fr,
       casey@schaufler-ca.com, serue@us.ibm.com, pavel@ucw.cz
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227124507.GB10661@basil.fritz.box>
References: <20091227010441.GA12077@heat> <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 05:36:48PM +0900, Tetsuo Handa wrote:
> Michael Stone wrote:
> > Further suggestions?
> 
> I expect that the future figure of this "disablenetwork" functionality becomes
> "disablesyscall" functionality.

That's basically apparmor. I believe it has been re-submitted 
recently.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
