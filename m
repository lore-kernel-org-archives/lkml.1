Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZHCM1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZHCM1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZHCM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:27:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:46960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZHCM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:27:41 -0400
Subject: Re: [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division 
 with rounding
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>, Julia Lawall <julia@diku.dk>
In-Reply-To: <20090803142138.51738a18@hyperion.delvare>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
	 <1249300672.7924.53.camel@twins> <20090803142138.51738a18@hyperion.delvare>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 14:27:21 +0200
Message-Id: <1249302441.7924.70.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 14:21 +0200, Jean Delvare wrote:
> > The proposed thing is simply DIV_ROUND, but this DIV_ROUND_CLOSEST name
> > is just wonky.
> 
> I can't disagree. I even think I argued about it back then, but then
> finally gave up. You should have participated in the debate when it was
> hot rather than 8 months later :(

Yeah, sometimes its hard to keep up with all on lkml, I only noticed it
because I ran into some code that used it.

Agreed on the other points.
