Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYCKU2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYCKU2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYCKU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:28:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYCKU2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:28:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: document CLD_CONTINUED notification mechanics
In-Reply-To: Oleg Nesterov's message of  Tuesday, 11 March 2008 21:36:06 +0300 <20080311183606.GE586@tv-sign.ru>
References: <20080309215338.GA2296@tv-sign.ru>
	<20080311021741.A863826F991@magilla.localdomain>
	<20080311183606.GE586@tv-sign.ru>
X-Shopping-List: (1) Ferocious faceers
   (2) Tempestuous photogenic mounds
   (3) Ruminating contraception geese
   (4) Repentant face witches
Message-Id: <20080311202817.3919F26F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 13:28:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I know. But the latter needs an extra line! [...]

It doesn't matter what your taste is, or mine.  That's why we have
conventions.  We just follow them and don't spend time grousing about
trivia.  The worst thing for a reader is to have the flow broken up by
inconsistent style.  New code follows the conventions.  Old code
(eventually) gets fixed up to follow the conventions.  End of story
(and a deathly dull one it is at that).


Thanks,
Roland
