Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbZGaIkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbZGaIkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZGaIki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:40:38 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:60369 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbZGaIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:40:37 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310840.n6V8eLlA006715@mercury.physics.adelaide.edu.au>
Subject: [PATCH 0/4] fujitsu-laptop: clean-ups and fixes
To: linux-acpi@vger.kernel.org
Date: Fri, 31 Jul 2009 18:10:21 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org, julia@diku.dk, bzolnier@gmail.com
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/4] fujitsu-laptop: clean-ups and fixes

This patch series against fujitsu-laptop contains corrections to NULL
pointer tests, removal of redundant tests, fixes to the driver
registration/unregistration and other minor cleanups.

The patches have been sourced from various authors - credits appear in the
individual patches.

Please consider applying to linux-acpi.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

Regards
  jonathan

