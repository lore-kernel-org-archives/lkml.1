Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYIBVzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYIBVzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYIBVzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:55:40 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59207 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYIBVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:55:40 -0400
Message-ID: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 2 Sep 2008 15:27:15 -0600 (MDT)
Subject: 2.6.27-rc5 acpi: EC Storm error message on bootup
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


See an ACPI: EC storm detected message, disabling EC

On both a compaq presario 2200 laptop and an Acer 9410 laptop.  Looks like
a brain dead error message not actually reporting any genuine errors.

Jeff

