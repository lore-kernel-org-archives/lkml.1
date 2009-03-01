Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZCAFHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZCAFHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 00:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZCAFHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 00:07:32 -0500
Received: from c60.cesmail.net ([216.154.195.49]:56562 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZCAFHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 00:07:31 -0500
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       ath5k-devel@venema.h4ckr.net
In-Reply-To: <20090227022704.GA29850@hash.localnet>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com>  <20090227022704.GA29850@hash.localnet>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 00:07:23 -0500
Message-Id: <1235884043.9224.12.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 21:27 -0500, Bob Copeland wrote:

> Actually, I remembered in the dark recesses of my moldering brain 
> that someone had a lost patch for this a while ago, so I searched
> the archives.  Pavel, ok to add your s-o-b?

Since my patch was dropped and the new patch was implemented without my
participation, it makes no sense to put my s-o-b on the code I didn't
write (even though I wrote something similar before).

-- 
Regards,
Pavel Roskin
