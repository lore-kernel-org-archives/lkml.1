Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZKRWjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZKRWjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZKRWjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:39:13 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39201 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZKRWjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gikDUGGu7yRRQFn0MNMNl7kgAYr52BhyJgpQjXihSLeQrJ34PcJCahASu8nwKNTtSx
         //RloulECrAHvTk/jYOVEZL3L6IVI1puNCNmEZTt8h8c+J8rO0zyfNnQe3e4zIgn9knD
         SsIRKJ74elePDUZ48GWSzaG9PvncMQmAMPu40=
Date: Wed, 18 Nov 2009 23:38:51 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091118223851.GA5191@ami.dom.local>
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
 <20091112113836.GA7963@ff.dom.local>
 <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
 <4AFC5C58.9030207@gmail.com>
 <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
 <20091113211640.GA2540@ami.dom.local>
 <81bfc67a0911180159g45a45675k44ce3f251c6bddea@mail.gmail.com>
 <20091118135136.GA9224@ff.dom.local>
 <81bfc67a0911181021n1b969565y4a39b181360b5e92@mail.gmail.com>
 <20091118201034.GA3060@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118201034.GA3060@ami.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 09:10:34PM +0100, Jarek Poplawski wrote:
> On Wed, Nov 18, 2009 at 01:21:19PM -0500, Caleb Cushing wrote:
> > yeah testing it under my known working config first. I'll get back w/ you later.
> 
> Btw, since dropping at hardware (NIC) level seems more likely to me,
> could you send 'ethtool eth0', and 'ethtool -S eth0' after such tests
> (both sides).

Hmm... and 'netstat -s' before and after the test (both sides).

Jarek P.
