Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZBAQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZBAQgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:36:12 -0500
Received: from verein.lst.de ([213.95.11.210]:49220 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZBAQgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:36:11 -0500
Date: Sun, 1 Feb 2009 17:35:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 2/5] Parse mount options just once and copy them to super block
Message-ID: <20090201163556.GF3416@lst.de>
References: <20090129064259.GA23160@us.ibm.com> <20090129064612.GC23160@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129064612.GC23160@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good (once the // check comment is cleaned up)
