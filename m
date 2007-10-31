Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbXJaRJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbXJaRJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXJaRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:08:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:32808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbXJaRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:08:54 -0400
Date: Wed, 31 Oct 2007 18:08:53 +0100
From: Jan Kara <jack@suse.cz>
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
Message-ID: <20071031170853.GD28809@atrey.karlin.mff.cuni.cz>
References: <871wbhc0zj.fsf@olafdietsche.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wbhc0zj.fsf@olafdietsche.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> This patch implements filesystem capabilities. It allows to
> run privileged executables without the need for suid root.
  Hmm, is there some "design document" so that one does not have to poke
through the code and find out what it's actually trying to do?
Also why don't you use extended attributes or store them inside the
executable like Pavel did (you link it from your web page).

								Honza
