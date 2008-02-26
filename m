Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbYBZXvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbYBZXvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765439AbYBZXv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:51:26 -0500
Received: from khc.piap.pl ([195.187.100.11]:35086 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765238AbYBZXvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:51:24 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, ricknu-0@student.ltu.se,
       bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
References: <1204062430.47c488def40a4@portal.student.luth.se>
	<20080226135444.f83a0536.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0802270033310.5714@axis700.grange>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 00:51:22 +0100
In-Reply-To: <Pine.LNX.4.64.0802270033310.5714@axis700.grange> (Guennadi Liakhovetski's message of "Wed\, 27 Feb 2008 00\:40\:43 +0100 \(CET\)")
Message-ID: <m31w6zcm4l.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Now, I think, I am not the only one using emacs. Until now the "linux" 
> C-style fitted perfectly with the CodingStyle, now it no longer will. 
> Namely, emacs puts as many tabs to indent the continuation line as fit 
> (i.e., at tab width = 8 spaces it's just (extra indent / 8) tabs plus 
> (extra indent % 8) spaces. Is there a way to make emacs behave compatibly 
> to this proposal? If not, I would not like to have to re-indent every such 
> line manually or have my patches rejected because of this.

Oh, I'm sure nobody will reject patches because of this now. It would
mean no patches are accepted.

Hopefully an elisp expert will implement it. Vim people probably need
something like that as well, and the list of editors is a bit longer...
-- 
Krzysztof Halasa
