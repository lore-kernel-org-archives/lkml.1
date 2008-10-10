Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbYJJTCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbYJJTCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761268AbYJJTBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:01:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762899AbYJJTBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:01:15 -0400
Date: Fri, 10 Oct 2008 12:00:50 -0700 (PDT)
Message-Id: <20081010.120050.161276431.davem@davemloft.net>
To: lrodriguez@atheros.com
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       jmalinen@atheros.com
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
	<20081010.115318.85254002.davem@davemloft.net>
	<43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 10 Oct 2008 12:00:17 -0700

> Agreed, patches welcomed.

Translation: "Fix it yourself if you care so much." :-/

