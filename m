Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYLDP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYLDP6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYLDP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:58:12 -0500
Received: from cet.com.ru ([195.178.208.66]:53700 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYLDP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:58:11 -0500
Date: Thu, 4 Dec 2008 18:58:09 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [W1] Added touch block command.
Message-ID: <20081204155809.GA30186@ioremap.net>
References: <12284022104086-git-send-email-zbr@ioremap.net> <122840221468-git-send-email-zbr@ioremap.net> <12284022143564-git-send-email-zbr@ioremap.net> <12284022144105-git-send-email-zbr@ioremap.net> <20081204154231.GC4864@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204154231.GC4864@gambetta>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 04:42:31PM +0100, Frederik Deweerdt (frederik.deweerdt@xprog.eu) wrote:
> On Thu, Dec 04, 2008 at 05:50:07PM +0300, Evgeniy Polyakov wrote:
> > -			cn->ack++
> > +			cn->ack++;
> Which we find here, sorry for the noise :-)

I know, It is a fix from the previous patch.
I just sent a patch series how it was committed, and yes, it contains
this error, I could resubmit with hand-edited patches if needed.

-- 
	Evgeniy Polyakov
