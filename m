Return-Path: <linux-kernel-owner+w=401wt.eu-S936116AbXJPVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936116AbXJPVjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935092AbXJPViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:38:50 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49591
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232AbXJPVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:49 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add Documentation/block/00-INDEX
Date: Tue, 16 Oct 2007 16:38:13 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200710150453.15484.rob@landley.net> <20071016081107.GE5045@kernel.dk>
In-Reply-To: <20071016081107.GE5045@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161638.14278.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 3:11:08 am Jens Axboe wrote:
> On Mon, Oct 15 2007, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Add Documentation/block/00-INDEX
>
> Not sure where this is heading, but I guess this one is fine with me.
> Applied.

I'm working towards full coverage of 00-INDEX files, because I use them to 
create index.html files for the web version at 
http://kernel.org/doc/Documentation (somewhere stable that Google can find 
it, regularly updated).  Then I run a 404 checker on those index.html files.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
