Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbYCFCic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbYCFCic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbYCFCiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:38:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33649
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760489AbYCFCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:38:16 -0500
Date: Wed, 05 Mar 2008 18:38:15 -0800 (PST)
Message-Id: <20080305.183815.46496526.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 03/16] atm: replace remaining __FUNCTION__ occurrences
From: David Miller <davem@davemloft.net>
In-Reply-To: <1204770292.14154.39.camel@brick>
References: <1204770292.14154.39.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 05 Mar 2008 18:24:52 -0800

> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied, thanks.
