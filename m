Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbYDPVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbYDPVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYDPVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:00:04 -0400
Received: from main.gmane.org ([80.91.229.2]:55827 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYDPVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:00:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jakub Narebski <jnareb@gmail.com>
Subject: Re: Reporting bugs and bisection
Followup-To: gmane.comp.version-control.git
Date: Wed, 16 Apr 2008 22:55:24 +0200
Organization: At home
Message-ID: <fu5p3i$96n$1@ger.gmane.org>
References: <48028830.6020703@earthlink.net> <alpine.DEB.1.10.0804131546370.9318@asgard> <20080414043939.GA6862@1wt.eu> <20080414053943.GU9785@ZenIV.linux.org.uk> <20080413232441.e216a02c.akpm@linux-foundation.org> <20080414072328.GW9785@ZenIV.linux.org.uk> <Xine.LNX.4.64.0804150131300.4160@us.intercode.com.au> <4804765B.2070300@davidnewall.com> <bd6139dc0804160515s64a36748v49556c56d475dda4@mail.gmail.com> <20080416132634.GA545@cs181133002.pp.htv.fi> <20080416200408.GA7764@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: abwk183.neoplus.adsl.tpnet.pl
Mail-Copies-To: Jakub Narebski <jnareb@gmail.com>
User-Agent: KNode/0.10.2
Cc: git@vger.kernel.org, netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> Note to contributors: it's very handy when patches comes with a properly
> formated subject. Try to put one of the following words between brackets
> to indicate the importance of the patch followed by a short description:
> 
> [MINOR]    minor fix, very low risk of impact
> [MEDIUM]   medium risk, may cause unexpected regressions of low importance or
>            which may quickly be discovered

[...]

And git-am strips such prefixes because of [PATCH] and [PATCH n/m] which
should be stripped.

-- 
Jakub Narebski
Warsaw, Poland
ShadeHawk on #git


