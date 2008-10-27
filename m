Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYJ0L3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYJ0L3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYJ0L2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:28:20 -0400
Received: from nn7.de ([85.214.94.156]:37258 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYJ0L2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:28:20 -0400
Subject: [2.6.28-rc2 regression] hangs on wakeup from s2ram
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2008 12:28:17 +0100
Message-Id: <1225106897.5125.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

my macbook pro 1,1 suspends nicely (s2ram) but on wakeup I see a black
screen...

Does anyone else observe this? As this was from within X (and it still
works in .27) I cannot give more details without further investigations
from the cmdline...

SOeren
