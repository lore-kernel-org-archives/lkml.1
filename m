Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKIRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKIRJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZKIRJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:09:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755001AbZKIRJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:09:00 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091109170854.161447000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 11:08:54 -0600
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 0/6] x86: UV - XPC fixes with related support functionality.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The UV BIOS has been updated to implement some of our interface
functionality differently than originally expected.  These patches
update us to that working bios and include a couple minor bug fixes
which prevent us from doing significant testing on real hardware.
