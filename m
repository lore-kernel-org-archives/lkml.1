Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZIPUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZIPUg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbZIPUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:36:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57597 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbZIPUgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:36:50 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200909161036.346507799@firstfloor.org>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/2] Updated patches for gold -X probing
Date: Wed, 16 Sep 2009 22:36:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


based on Sam's feedback using a new macro.

gold build doesn't work currently for some other reasons,
but I haven't investigated that yet. It seems to be new though,
wasn't there a few rc*s ago.

-Andi

