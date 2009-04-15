Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbZDOMAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbZDOMAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbZDOMAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:00:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46842 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZDOMAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:00:33 -0400
Date: Wed, 15 Apr 2009 13:00:32 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/1] INPUT: mainstone-wm97xx, fix condition in pen_up
Message-ID: <20090415120032.GC9311@sirena.org.uk>
References: <1239777830-17826-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239777830-17826-1-git-send-email-jirislaby@gmail.com>
X-Cookie: System checkpoint complete.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 08:43:50AM +0200, Jiri Slaby wrote:
> The loop body was never executed, because the condition is
> always false. Convert to for with more obvious condition.

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
