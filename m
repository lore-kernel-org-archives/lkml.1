Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXF1Lgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXF1Lgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXF1Lg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:36:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48723 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbXF1Lg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:36:28 -0400
Subject: Re: Userspace compiler support of "long long"
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>, david@lang.hm,
       linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706281333320.24833@anakin>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182483527.10524.31.camel@shinybook.infradead.org>
	 <20070622150038.GN23017@stusta.de>
	 <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
	 <20070627154046.GN1094@stusta.de>
	 <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
	 <20070627173240.GR1094@stusta.de>
	 <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
	 <20070627155715.60ebc48f.randy.dunlap@oracle.com>
	 <20070627161648.52d3786d.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0706280411520.26289@anakin>
	 <Pine.LNX.4.64.0706280844030.22579@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0706281333320.24833@anakin>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 12:36:14 +0100
Message-Id: <1183030574.1170.137.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 13:34 +0200, Geert Uytterhoeven wrote:
> We do not support building Linux with Turbo C (or MS Visual C for
> Win64 P64). 

We're talking about types which are exposed to userspace.

-- 
dwmw2

