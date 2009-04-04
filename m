Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZDDQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZDDQU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZDDQUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:20:13 -0400
Received: from n28.bullet.mail.mud.yahoo.com ([68.142.206.223]:34724 "HELO
	n28.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753520AbZDDQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:20:12 -0400
X-Yahoo-Newman-Id: 885210.95739.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=grpmoi/WnQ9fVmCFT3I6Aakf4QWXtJ5tdER73jICqUAyibbWdDvcMu3s+d4Jl0NFbripD9iGLwENsdoL8FPyiNHwd0iOBuWXP8/ji8/0+NWFsMJyAB2aCSmkQGzseHrv91yz1EkfxOieOrXf3Q4FpWwNmxy25KptaA+Ak1DrJ2k=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Date: Sat, 4 Apr 2009 09:20:06 -0700
User-Agent: KMail/1.9.10
Cc: Kevin Cernekee <kpc.mtd@gmail.com>, dedekind@infradead.org,
       Linux MTD <linux-mtd@lists.infradead.org>, linux-kernel@vger.kernel.org
References: <200903260042.42091.david-b@pacbell.net> <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com> <1238855797.4068.6.camel@macbook.infradead.org>
In-Reply-To: <1238855797.4068.6.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904040920.06981.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009, David Woodhouse wrote:
> think I'm going to add a WARN_ON(&mtd->dev.parent) into the core code.

I hope you mean WARN_ON(!mtd->dev.parent) ... :)




