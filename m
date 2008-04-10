Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYDJABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYDJABR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDJABE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:01:04 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:15354 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753306AbYDJABE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:01:04 -0400
Date: Wed, 09 Apr 2008 18:01:00 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/2] EDAC Cleanup patch and module initialize fix
Message-ID: <47fd58bc.Oxr1e/hw/f9dVj9B%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Applied to 2.6.25-rc8-mm1

EDAC patches

Cleanup patch for removing unneeded functions and #if 0 function for
future use. Add static accessor attribute

2nd submission on the EDAC module initialization clean patch

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
