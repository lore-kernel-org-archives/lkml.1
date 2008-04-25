Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYDYAog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYDYAog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbYDYAoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:44:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60201
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbYDYAoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:44:23 -0400
Date: Thu, 24 Apr 2008 17:44:22 -0700 (PDT)
Message-Id: <20080424.174422.247187375.davem@davemloft.net>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: [PATCH 18/24] sparc: types: use <asm-generic/int-*.h> for the
 sparc architecture
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209078352-7593-36-git-send-email-hpa@zytor.com>
References: <1209078352-7593-34-git-send-email-hpa@zytor.com>
	<1209078352-7593-35-git-send-email-hpa@zytor.com>
	<1209078352-7593-36-git-send-email-hpa@zytor.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 Apr 2008 16:05:42 -0700

> This modifies <asm-sparc/types.h> to use the <asm-generic/int-*.h>
> generic include files.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
