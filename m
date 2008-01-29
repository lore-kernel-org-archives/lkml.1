Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbYA2PuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbYA2PuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYA2Pt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:49:56 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52954 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbYA2Ptz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:49:55 -0500
Message-Id: <20080129154900.145303789@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 29 Jan 2008 16:49:00 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/6] mm: bdi: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series from Peter Zijlstra, with various updates by me.  The
patchset mostly deals with exporting BDI attributes in sysfs.

Should be in a mergeable state, at least into -mm.

--
