Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbXK3Ava@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbXK3Ava (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762009AbXK3AvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:51:23 -0500
Received: from namei.org ([69.55.235.186]:34051 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757173AbXK3AvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:51:22 -0500
Date: Fri, 30 Nov 2007 11:50:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Al Viro <viro@ftp.linux.org.uk>
cc: Valdis.Kletnieks@vt.edu, Jon Masters <jonathan@jonmasters.org>,
       Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: <20071129220842.GZ8181@ftp.linux.org.uk>
Message-ID: <Xine.LNX.4.64.0711301147160.28541@us.intercode.com.au>
References: <20071128183040.GW8181@ftp.linux.org.uk>
 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
 <20071129173601.34273083@the-village.bc.nu>
 <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
 <1196362612.6473.98.camel@perihelion> <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
 <1196365551.6473.103.camel@perihelion> <2812.1196369788@turing-police.cc.vt.edu>
 <20071129220842.GZ8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Al Viro wrote:

> Incidentally, I would really love to see the threat profile we are talking
> about.  

Exactly.

Please come up with a set of requirements that can be reviewed by the core 
kernel folk, and perhaps then focus on how to meet those requirements once 
they have been accepted.



- James
-- 
James Morris
<jmorris@namei.org>
