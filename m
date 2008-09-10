Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYIJS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYIJS2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYIJS22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:28:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37938 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751126AbYIJS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:28:27 -0400
Date: Wed, 10 Sep 2008 19:28:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] WM8400 support
Message-ID: <20080910182825.GB16721@rakim.wolfsonmicro.main>
Mail-Followup-To: Samuel Ortiz <sameo@openedhand.com>,
	Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: A watched clock never boils.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches against the regulator development tree add basic support
for the WM8400, an audio CODEC and PMU targeted at multimedia systems,
covering basic PMIC functionality only.  Since the functionality of the
device covers multiple subsystems with arbitration required a core
driver is provided in drivers/mfd.

Samuel, I guess it makes sense to merge this via the regulator tree?
