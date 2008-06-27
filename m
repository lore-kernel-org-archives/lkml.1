Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbYF0XQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbYF0XQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765506AbYF0XHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:07:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765593AbYF0XHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:07:08 -0400
Date: Fri, 27 Jun 2008 16:06:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/13] EDAC i5100 fix unmask ecc bits
Message-Id: <20080627160641.70794381.akpm@linux-foundation.org>
In-Reply-To: <48652db4.9eBuCDarQoo9vl8F%dougthompson@xmission.com>
References: <48652db4.9eBuCDarQoo9vl8F%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So... is there any reason why we shouldn't fold patches 2, 3 and 4 into #1?
