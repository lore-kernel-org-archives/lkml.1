Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXH3Kj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXH3Kj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXH3KjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:39:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXH3KjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:39:19 -0400
Date: Thu, 30 Aug 2007 12:35:11 +0200
From: andre@finow14.de
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [KJ][patch 0/3] use abs() from kernel.h where appropriate
Message-ID: <20070830103511.GA14925@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX19VlKaHcImDNCK1fpbyWKqOQx/yGN7wdhVYHZV
 YnYS1hx7HdK/tVTxyQTG7hxDUfIKgLwbRicWhYvctAc0Oj71OV
 oRfTSG1DPNQyPYb2s+GUQxvoFpc4B7v
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This small series of quite trivial patches converts a own definition
of the abs macro to the one from kernel.h and replaces some inline
calculations of abs with the macro.

--
