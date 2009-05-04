Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZEDKen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZEDKen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZEDKef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:34:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZEDKee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:34:34 -0400
Subject: btusb auto suspend
From: Peter Zijlstra <peterz@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 12:34:31 +0200
Message-Id: <1241433271.7620.4748.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel, Oliver,

What is the current status of btusb auto suspend? btusb not having this
feature basically renders BT useless on mobile devices.

I found some rfc patches and discussion over on linux-pm/-usb but
couldn't find a clear consensus.

 ~ Peter
