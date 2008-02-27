Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbYB0W17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbYB0W17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYB0W1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:27:47 -0500
Received: from namei.org ([69.55.235.186]:43015 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYB0W1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:27:46 -0500
Date: Thu, 28 Feb 2008 09:25:42 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Paul Moore <paul.moore@hp.com>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 3/4] Audit: start not to use SELinux exported symbols
In-Reply-To: <20080227171158.GB27965@ubuntu>
Message-ID: <Xine.LNX.4.64.0802280924440.19162@us.intercode.com.au>
References: <20080226232229.GA12059@ubuntu> <20080226232808.GD12059@ubuntu>
 <200802271100.57487.paul.moore@hp.com> <20080227171158.GB27965@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Ahmed S. Darwish wrote:

> Thanks a lot for such a deep review :). I'll modify spotted problems
> as suggested, reorder the patch in a non compilation-breaking order, 
> and keep you informed.
> 
> Modified patches will be sent with the new ones that will complete 
> the separation not to add too much noise in LKML.

I'm not quite sure what this means, but you should resend the whole 
patchset.


- James
-- 
James Morris 
<jmorris@namei.org>

