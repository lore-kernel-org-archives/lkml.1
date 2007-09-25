Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXIYSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXIYSO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXIYSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:14:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17339 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXIYSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qkVfXd9DucrXWMbkIeTTyjs9gBKlQZoouESEKQY65QoJ1pwGFYZTP5tn7MDdaCh1PCHehQN/4DQwWBvrRU8HeIj9vI2exoOJMuOAPTHGsQx2H0Ka1ZUs2pvi+ZAOIWJhNqMcDLNr3BK1gxehogWUVJMGs6Pk149+Z1C7DphAwyU=
Message-ID: <46F94FF3.1000400@gmail.com>
Date: Tue, 25 Sep 2007 12:14:11 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org>
In-Reply-To: <46F8665A.4000206@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

> The first step would be to clone the "upstream" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> and see if the problem is reproducible there.  If yes, then you have
> narrowed down the problem to something my ATA devel tree has introduced
> into -mm.

Nope, you're off the hook.  The libata tree works great, so it must be
something else in -mm conflicting.
