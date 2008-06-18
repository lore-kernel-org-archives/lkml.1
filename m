Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYFRVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYFRVsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYFRVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:48:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42829
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbYFRVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:48:30 -0400
Date: Wed, 18 Jun 2008 14:48:30 -0700 (PDT)
Message-Id: <20080618.144830.35409576.davem@davemloft.net>
To: rweikusat@mssgmbh.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.7] af_unix: fix 'poll for write'/ connected
 DGRAM sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <874p7qsz5g.fsf@fever.mssgmbh.com>
References: <871w2wca3r.fsf@fever.mssgmbh.com>
	<20080617.215630.47207590.davem@davemloft.net>
	<874p7qsz5g.fsf@fever.mssgmbh.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Wed, 18 Jun 2008 14:31:07 +0200

> I will submit an updated patch which addresses this.

Please submit a relative patch with the fixups, your
original change is already in my tree.
