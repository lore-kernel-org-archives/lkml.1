Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbYEPPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbYEPPc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYEPPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:32:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36372 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYEPPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:32:46 -0400
Date: Fri, 16 May 2008 17:32:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dave Quigley <dpquigl@tycho.nsa.gov>
cc: hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/67] aufs document
In-Reply-To: <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <alpine.LNX.1.10.0805161731080.15590@fbirervta.pbzchgretzou.qr>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 16:59, Dave Quigley wrote:

>A couple of comments about this. First off you might want to reconsider
>how you are breaking up the patches. 67 patches seems a bit much to me
>and while the separation between patches is clear it seems that some of
>them can be folded. Second I'm not sure if I haven't gotten it yet or if
>it wasn't sent but I am missing an Email 0/67. Typically this contains a

No 0/67 unfortunately, and --no-chain was also missing when calling
git-send-email. (Argh, git-send-email should default to no-chain!)
