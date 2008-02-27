Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYB0ACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYB0ACq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYB0ACg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:02:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44834 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYB0ACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:02:36 -0500
Date: Wed, 27 Feb 2008 01:02:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, ricknu-0@student.ltu.se,
       bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
In-Reply-To: <m31w6zcm4l.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0802270057310.15321@fbirervta.pbzchgretzou.qr>
References: <1204062430.47c488def40a4@portal.student.luth.se>
 <20080226135444.f83a0536.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802270033310.5714@axis700.grange> <m31w6zcm4l.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27 2008 00:51, Krzysztof Halasa wrote:
>Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
>> Now, I think, I am not the only one using emacs. Until now the "linux" 
>> C-style fitted perfectly with the CodingStyle, now it no longer will. 
>> Namely, emacs puts as many tabs to indent the continuation line as fit 
>> (i.e., at tab width = 8 spaces it's just (extra indent / 8) tabs plus 
>> (extra indent % 8) spaces. Is there a way to make emacs behave compatibly 
>> to this proposal? If not, I would not like to have to re-indent every such 
>> line manually or have my patches rejected because of this.
>
>Oh, I'm sure nobody will reject patches because of this now. It would
>mean no patches are accepted.

Correct. Just did not want to even encourage any newcomers to use
tabs when spacing is needed. Though, some editors unfortunately do
just that - replacing 8 spaces by tabs on a new line when autoindent
is on, like mcedit :-(
