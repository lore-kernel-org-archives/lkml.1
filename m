Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbYJSOPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbYJSOPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYJSOPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:15:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38912 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYJSOPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:15:46 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 19 Oct 2008 07:15:39 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Hugh Dickins <hugh@veritas.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Ben Castricum <lk0810@bencastricum.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: NULL pointer derefence since 2.6.27 in (e)poll
In-Reply-To: <Pine.LNX.4.64.0810191346001.26362@blonde.site>
Message-ID: <Pine.LNX.4.64.0810190714490.23581@alien.or.mcafeemobile.com>
References: <6F31A6373E3D42EDAED26A994BA0830D@Seven>
 <84144f020810190445r12154ae0p271037ae130b653b@mail.gmail.com>
 <Pine.LNX.4.64.0810191346001.26362@blonde.site>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Hugh Dickins wrote:

> Isn't it the issue fixed by
> 
> http://marc.info/?l=linux-kernel&m=122428548613067&w=2

Not sure, but it may very well be.


- Davide


