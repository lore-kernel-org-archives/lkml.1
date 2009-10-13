Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbZJMH30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbZJMH30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933690AbZJMH30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:29:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688AbZJMH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:29:25 -0400
Date: Tue, 13 Oct 2009 09:28:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Hibernate: add \n to load_image fail path
Message-ID: <20091013072841.GD18997@elf.ucw.cz>
References: <4AD39FBA.6000509@gmail.com>
 <1255383530-6778-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255383530-6778-1-git-send-email-jirislaby@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-10-12 23:38:50, Jiri Slaby wrote:
> Finish a line by \n when load_image fails in the middle of loading.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
