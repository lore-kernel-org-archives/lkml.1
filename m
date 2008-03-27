Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYC0Bke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYC0Bke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYC0BkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:40:23 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44006 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbYC0BkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:40:22 -0400
Date: Wed, 26 Mar 2008 19:29:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       NeilBrown <neilb@suse.de>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu,
       viro@zeniv.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080327002930.GA13960@sergelap.austin.ibm.com>
References: <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <18408.26863.617591.836548@notabene.brown> <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp> <57096.192.168.1.70.1206484328.squirrel@neil.brown.name> <1206533042.3302.266.camel@moss-spartans.epoch.ncsc.mil> <20080326164753.GA20578@sergelap.ibm.com> <Xine.LNX.4.64.0803270834070.1952@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803270834070.1952@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 26 Mar 2008, Serge E. Hallyn wrote:
> 
> > Not only that, but containers require an LSM to provide user isolation
> > and root containment.
> 
> You mean LSM hooks, which various LSM could utilize if desired, right?

Yes.

thanks,
-serge
