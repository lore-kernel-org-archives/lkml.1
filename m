Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYELORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYELORQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYELORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:17:00 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:50411 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYELOQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:16:59 -0400
X-ME-UUID: 20080512132105818.C7CDA1C002F6@mwinf1901.orange.fr
Date: Mon, 12 May 2008 15:20:25 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: David Miller <davem@davemloft.net>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080512132025.GF6714@implementation.home>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Michael Kerrisk <mtk.manpages@googlemail.com>,
	David Miller <davem@davemloft.net>, andi@firstfloor.org,
	linux-kernel@vger.kernel.org
References: <20080424001656.GM4825@implementation> <517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com> <20080426014445.GD4792@implementation> <20080426.225432.128575953.davem@davemloft.net> <482841AC.4020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <482841AC.4020609@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Michael Kerrisk, le Mon 12 May 2008 15:10:04 +0200, a écrit :
> I have drafted a revision to section of the unix.7 page describing the address
> format to try and cover all of the above.

Looks much more clear.

Samuel

