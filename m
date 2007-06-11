Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXFKSyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXFKSyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXFKSxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:53:53 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:52359 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbXFKSxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:53:52 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: Darren Jenkins <darrenrjenkins@gmail.com>,
       Jan-Benedict Glaw <jbglaw@lug-owl.de>, kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Date: Mon, 11 Jun 2007 20:53:31 +0200
User-Agent: KMail/1.9.5
References: <200706101235.09578.lists-receive@programmierforen.de> <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com> <20070611174706.GA9150@pingi.kke.suse.de>
In-Reply-To: <20070611174706.GA9150@pingi.kke.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706112053.31933.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1181588032;c58ff167;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> Agree, here is a new version.
> 
> This patch replaces various array size calculations in drivers/isdn/hisax
> done using sizeof with the ARRAY_SIZE macro.
Thanks for the work Karsten.

	Andi
