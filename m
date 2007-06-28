Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXF1GwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXF1GwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbXF1GwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:52:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:19058 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062AbXF1GwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:52:05 -0400
Date: Thu, 28 Jun 2007 08:52:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: dave young <hidave.darkstar@gmail.com>
cc: Josh Triplett <josh@kernel.org>, Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
In-Reply-To: <a8e1da0706272329j42997c3eh49a1b20df5892a0e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706280850470.22579@fbirervta.pbzchgretzou.qr>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com> 
 <20070627180552.GA746@pe.Belkin>  <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>
  <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com> 
 <46835047.8080600@kernel.org> <a8e1da0706272329j42997c3eh49a1b20df5892a0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 28 2007 06:29, dave young wrote:
>
> IMHO, another  cause of trailing whitespace is human error, for
> example long lines breaking will easy to cause the first line with one
> traling whitespace (original space between the last two words).

Most common errors (to me) are:

 - hit return+tab too quickly that it interchanges, hence producing
   the unwanted \t\n
 - hit return+return to start a new paragraph of code;
   the intermediate line remains indented if autoindent is on.


	Jan
-- 
