Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbYDPLXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbYDPLXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbYDPLXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:23:43 -0400
Received: from main.gmane.org ([80.91.229.2]:35722 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbYDPLXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:23:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: [newb] mmap pci
Date: Wed, 16 Apr 2008 07:23:29 -0400
Message-ID: <fu4njh$4aa$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 139.85.239.127
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a device - an FPGA board on PCI bus.  It has a range of internal
memory mapped to PCI.  I want to expose this to user via mmap.  Is there
some example code someone could point me to?

If this is not the best forum for such questions, what would be a better
choice?

