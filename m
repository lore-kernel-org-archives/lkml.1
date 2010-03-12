Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0CLHKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:10:12 -0500
Received: from mx51.mymxserver.com ([85.199.173.110]:35553 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0CLHKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:10:10 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: cfg80211 conversion of all drivers
Date: Fri, 12 Mar 2010 08:10:37 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-rc8; KDE/4.4.1; i686; ; )
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, devel@driverdev.osuosl.org,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <43e72e891003111722n4b4d5b6crf764dfe357ff8965@mail.gmail.com> <69e28c911003111756h224ef6a9x622c979232b6698b@mail.gmail.com> <20100312025330.GA15402@tuxdriver.com>
In-Reply-To: <20100312025330.GA15402@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003120810.38194.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that is code for "replace it with something based on mac80211"...

That's not going to happen, hostap + orinoco both work against fullmac chips, 
which can't send arbitrary packets and therefore no 802.11 management frames.

-- 
http://www.holgerschurig.de
