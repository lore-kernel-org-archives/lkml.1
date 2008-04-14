Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYDNPN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYDNPN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYDNPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:13:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54400 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbYDNPNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:13:14 -0400
Date: Mon, 14 Apr 2008 17:13:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       akpm@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in
 Documentation/filesystems/seq_file.txt
In-Reply-To: <4802C265.8060802@gmail.com>
Message-ID: <alpine.LNX.1.10.0804141709060.9651@fbirervta.pbzchgretzou.qr>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com> <48028841.900@gmail.com> <20080413224547.GS9785@ZenIV.linux.org.uk> <20080413190916.57cede66.randy.dunlap@oracle.com>
 <4802C265.8060802@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-04-14 04:33, Dmitri Vorobiev wrote:
>
>To put it briefly, there are three main conventions about inter-sentence
>spacing:
>
>o English spacing a.k.a. American typewriter spacing: two spaces after full stop;
>
>o French spacing, i.e. one space;

French spacing has even weirder inter-word/operator spacing,
like « this » and that !

>Offhand, it seems that the double spacing convention is being currently used
>in a more or less consistent manner throughout Linux docs. It also seems to
>me that this can be made a requirement and documented somewhere.

I object. No matter how many (unescaped) spaces you cram in after a sentence
stop, HTML engines will happily squash it when displayed [in text/html
mode of course], like <p>do as much english spacing.       as you want,
it's still correctly fixed by the display :-)</p>.

