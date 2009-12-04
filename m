Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZLDOud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZLDOud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZLDOuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:50:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34555 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZLDOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:50:31 -0500
Date: Fri, 4 Dec 2009 09:14:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v7 8/8] Loongson: YeeLoong: add input/hotkey driver
Message-ID: <20091204081402.GD1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com> <7e96d37889c49c2d6d284e21773aef90dd3aac25.1259932036.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e96d37889c49c2d6d284e21773aef90dd3aac25.1259932036.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> +#define NO_REG		0
> +#define NO_HANDLER	NULL

Don't obfuscate code like that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
