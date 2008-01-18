Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbYARMY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbYARMY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYARMYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:24:18 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40629 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622AbYARMYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:24:17 -0500
X-Sasl-enc: dWi9yStj5jiQyW80fQw1Hvg9yKwm+/BBoSk+Irf2F9hr 1200659056
Date: Fri, 18 Jan 2008 10:24:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080118122411.GA8301@khazad-dum.debian.net>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist> <20080117211205.GE8953@1wt.eu> <20080117214755.GB28233@does.not.exist> <20080117213225.GF8953@1wt.eu> <20080117220219.GA22980@khazad-dum.debian.net> <20080117214836.GG8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117214836.GG8953@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Willy Tarreau wrote:
> Well, since there are commands that work on this (push and log at
> least), I believe that some operations could succeed. I *know* that
> remote cloning was impossible, and it *looked* like pulling too was
> during my attempts to fix the problem before understanding its root
> cause. It is possible that I cumulated problems though, if at least
> two people could pull from it.

Ah, I think I recalled something about the episode.  I knew the tag was
there (gitweb), and I did have some trouble to get it, but I *think* what
worked out was:

git fetch <repo> <tag>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
