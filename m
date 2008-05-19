Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYESNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYESNK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYESNKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:10:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45424 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYESNKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:10:46 -0400
X-Sasl-enc: 74b9U0LHJ/Y3gh/7bd15DfiSp5o6nA/dyeeygq9U9fgf 1211202645
Date: Mon, 19 May 2008 10:10:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH 11/15] rfkill: add notifier chains support
Message-ID: <20080519131042.GA31587@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-12-git-send-email-hmh@hmh.eng.br> <1211186644.21269.274.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211186644.21269.274.camel@queen.suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Thomas Renninger wrote:
> > + * Calls to this chain may have been done through a workqueue.  One must
> > + * one must assume unordered assynchronous behaviour, there is no way to
> One must, one must...,         asynchronous
> ...

Will fix.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
