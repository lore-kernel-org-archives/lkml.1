Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXK1Qiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXK1Qiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759856AbXK1Qio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:38:44 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:48999 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759804AbXK1Qio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:38:44 -0500
X-YMail-OSG: mtpAa6EVM1k0OSmNqnVQTt8IrP7RzJTQPhLJwu_ViC4.smPXLdwKCyCTKfEp2wn7YYVotNWryQhZr5QUDTYYBU52qM3NJMEt7C7p1WPM_x95o9nP_lc-
X-RocketYMMF: rancidfat
Date: Wed, 28 Nov 2007 08:38:43 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Out of tree module using LSM
To: Christoph Hellwig <hch@infradead.org>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071128144156.GA14106@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <416908.77038.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Nov 28, 2007 at 12:42:52PM +0000, Tvrtko A. Ursulin wrote:
> > 
> > Hi Linus, all,
> > 
> > During one recent LKML discussion 
> > (http://marc.info/?l=linux-kernel&m=119267398722085&w=2) about LSM going 
> > static  you called for LSM users to speak up.
> > 
> > We here at Sophos (the fourth largest endpoint security vendor in the
> world) 
> > have such a module called Talpa which is a part of our main endpoint
> security 
> > product for Linux  that protects from viruses and malware hosted on Linux, 
> > including those targetting Windows or other connected devices,  
> >
>
(http://www.sophos.com/products/enterprise/endpoint/security-and-control/linux/index.html)
> 
> > which is GPL code and has been in the field for almost three years now.
> It's 
> > source code has been shipping with the product from the start.  We also
> have 
> > a SourceForge project at http://sourceforge.net/projects/talpa/ to host it.
> 
> Thanks for showing a wonderful source code example of why lsm shouldn't
> be exported :)

Would you like to expound on that, or do you feel your claws
are sharp enough already?


Casey Schaufler
casey@schaufler-ca.com
