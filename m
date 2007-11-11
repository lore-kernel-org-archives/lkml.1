Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXKKDc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXKKDc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXKKDcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:32:19 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47735 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXKKDcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:32:18 -0500
Date: Sat, 10 Nov 2007 22:32:09 -0500
Message-Id: <200711110332.lAB3W9on007709@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: NFSv4 broken in -mm (MMOM "10-Nov-2007 22:46")
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46".  Creating dummy f/s and exporting it to localhost, mounting it as
nfsv4, then

# touch foo
touch: setting times of `foo': No such file or directory
# echo > bar
bar: Invalid argument

Erez.
