Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXIRXpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXIRXpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXIRXp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:45:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55962 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXIRXp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:45:28 -0400
Date: Wed, 19 Sep 2007 05:18:16 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <3BBEDBBC-FD71-4A6F-81B3-EC0978A37024@mac.com>
Message-ID: <alpine.LFD.0.999.0709190515320.26241@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
 <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
 <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
 <1189142049.6681.29.camel@heimdal.trondhjem.org>
 <3BBEDBBC-FD71-4A6F-81B3-EC0978A37024@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Sep 2007, Kyle Moffett wrote:
> 
> So you can't draw any relationships between "Protect the end-user" with
> "Protect the device FROM the end-user", the former can be done very reliably
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^ *attacker*

> to whatever level of risk-reduction you need and the latter can't practically
> be done at all.

Well, you're the one who called solving the physical access problem
"easy" here ... :-)
