Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXFYUcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXFYUcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXFYUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:32:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57162 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXFYUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:32:28 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: harald@skogtun.org, schilling@fokus.fraunhofer.de,
       linux-kernel@vger.kernel.org, david@lang.hm
In-Reply-To: <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182483527.10524.31.camel@shinybook.infradead.org>
	 <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182785277.12109.121.camel@pmac.infradead.org>
	 <87wsxrdi6e.fsf@basilikum.skogtun.org>
	 <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 21:32:18 +0100
Message-Id: <1182803538.12109.146.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 22:26 +0200, Joerg Schilling wrote:
> Well, I was in hope that a small typo (in special as the correct
> spelling is in the file README.compile) should not be a problem.
> 
> You need to use CCOM=suncc 

No, I need someone else to use CCOM=suncc for me. Unless suncc works on
Linux/PowerPC _and_ you find me a few extra hours in the day to deal
with bugs for someone who can't even be bothered to write a coherent bug
report.

-- 
dwmw2

