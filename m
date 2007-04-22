Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXDVL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXDVL3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXDVL3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:29:01 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:49559 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbXDVL3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:29:01 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Wrong free clusters count on FAT32
Date: Sun, 22 Apr 2007 13:28:54 +0200
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp>
In-Reply-To: <87d51xtkmp.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221328.55172.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 22 April 2007 00:42, OGAWA Hirofumi wrote:
> Yes. It seems that Windows does not update the ->free_clusters correctly.
> Probably, I think the option is good for now. What do you think about
> an attached patch?

Please don't ask me, because I'm not a filesystem expert. Sorry. My suggestion 
was only a tiny idea.

Juergen
