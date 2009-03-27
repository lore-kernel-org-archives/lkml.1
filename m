Return-Path: <linux-kernel-owner+w=401wt.eu-S1762907AbZC0FP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907AbZC0FP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZC0FPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:15:49 -0400
Received: from kuber.nabble.com ([216.139.236.158]:49538 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZC0FPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:15:48 -0400
Message-ID: <22736146.post@talk.nabble.com>
Date: Thu, 26 Mar 2009 22:15:46 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Copy-on-write
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the kernel does a COW, say from a "src" to a "dest" page, does it need
to map the "src" and "dest" page to its address space or the kernel can
directly initiate the read from "src" and write to "dest" page ?

Thanks,
SC
-- 
View this message in context: http://www.nabble.com/Copy-on-write-tp22736146p22736146.html
Sent from the linux-kernel mailing list archive at Nabble.com.

