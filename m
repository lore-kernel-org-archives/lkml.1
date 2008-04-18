Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYDRBNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYDRBNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 21:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYDRBM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 21:12:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbYDRBM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 21:12:58 -0400
Date: Thu, 17 Apr 2008 18:13:00 -0700 (PDT)
Message-Id: <20080417.181300.88940365.davem@davemloft.net>
To: kernel1@cyberdogtech.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipsec blocking issue in 2.6.25 (and earlier)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080417193350.8e615006.kernel1@cyberdogtech.com>
References: <20080417193350.8e615006.kernel1@cyberdogtech.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


echo "1" >/proc/sys/net/core/xfrm_larval_drop
