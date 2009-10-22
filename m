Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZJVGDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZJVGDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZJVGCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39444 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZJVGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:29 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com
Subject: HWPOISON updates for 2.6.32-rc5 for review
Date: Thu, 22 Oct 2009 08:02:24 +0200
Message-Id: <1256191352-6903-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <i>
References: <i>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the hwpoison bug fixes queued up for 2.6.32-rc5. In particularly
they fix the page flags races that were discussed earlier and a couple of
random bug fixes. 

Please review.

-Andi


