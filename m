Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbYCZVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbYCZVnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYCZVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:43:05 -0400
Received: from namei.org ([69.55.235.186]:36629 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756240AbYCZVnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:43:03 -0400
Date: Thu, 27 Mar 2008 08:35:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, NeilBrown <neilb@suse.de>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu,
       viro@zeniv.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org
Subject: Re: r-o bind in nfsd
In-Reply-To: <20080326164753.GA20578@sergelap.ibm.com>
Message-ID: <Xine.LNX.4.64.0803270834070.1952@us.intercode.com.au>
References: <20080321155451.GU10722@ZenIV.linux.org.uk>
 <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk>
 <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <18408.26863.617591.836548@notabene.brown>
 <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp>
 <57096.192.168.1.70.1206484328.squirrel@neil.brown.name>
 <1206533042.3302.266.camel@moss-spartans.epoch.ncsc.mil>
 <20080326164753.GA20578@sergelap.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Serge E. Hallyn wrote:

> Not only that, but containers require an LSM to provide user isolation
> and root containment.

You mean LSM hooks, which various LSM could utilize if desired, right?


- James
-- 
James Morris
<jmorris@namei.org>
