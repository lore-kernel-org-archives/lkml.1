Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZGIE3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZGIE3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZGIE2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:28:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59359 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbZGIE2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:28:53 -0400
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <yq1my7eg52w.fsf@sermon.lab.mkp.net>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
	 <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	 <1247063244.4159.40.camel@mulgrave.site>
	 <yq1my7eg52w.fsf@sermon.lab.mkp.net>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 23:28:47 -0500
Message-Id: <1247113727.4159.285.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 18:52 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> You might also try this patch from martin petersen: it will print
> James> out the actual command that's causing the problems ... that might
> James> give a clue.
> 
> Any particular reason you didn't merge that patch, btw.?  It's been
> extremely useful on this end...

No-one reminded me ... until the potential debugging use triggered a
memory.

James


