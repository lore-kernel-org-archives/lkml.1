Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXGMCuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXGMCuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXGMCuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:50:04 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:49441 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXGMCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:50:03 -0400
Date: Thu, 12 Jul 2007 22:49:59 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [GIT] SELinux changes for 2.6.23 (updated)
In-Reply-To: <6bffcb0e0707121639y43020few7fffe3077c4544d7@mail.gmail.com>
Message-ID: <Line.LNX.4.64.0707122249250.13816@d.namei>
References: <Line.LNX.4.64.0707112315480.30564@d.namei>
 <6bffcb0e0707121639y43020few7fffe3077c4544d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Michal Piotrowski wrote:

> 
> My system is too secure, I can not login :)

Do you have CONFIG_NETLABEL=y ?

If so, please try disabling it.


- James
-- 
James Morris
<jmorris@namei.org>
