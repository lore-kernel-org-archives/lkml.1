Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbZDBU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbZDBU2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761615AbZDBU2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:28:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39446 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761134AbZDBU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:28:00 -0400
Date: Thu, 2 Apr 2009 22:27:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-pm@lists.linux-foundation.org,
       Eric Piel <eric.piel@tremplin-utc.net>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>
Subject: Re: [PATCH 2/9] hp_accel: remove unused #include <version.h>
Message-ID: <20090402202742.GC16460@elf.ucw.cz>
References: <1238686212-3920-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238686212-3920-1-git-send-email-weiyi.huang@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-02 23:30:12, Huang Weiyi wrote:
> Remove unused #include <version.h> in drivers/hwmon/hp_accel.c.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
