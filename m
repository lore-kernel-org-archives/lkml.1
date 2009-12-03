Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZLCWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZLCWfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZLCWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:35:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:55081 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbZLCWfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:35:43 -0500
Message-Id: <20091203223414.393107000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 03 Dec 2009 16:34:14 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 0/2] GRU - GRU Updates - GRU Update for cross SSI interrupts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset contains two patches to the GRU driver for
sending interrupts to other SSIs in the numalink domain.

No changes are made to non-UV files.


