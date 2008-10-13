Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYJMRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYJMRtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYJMRtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:49:04 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:51227 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYJMRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:49:03 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question about pci_disable_device
Date: Mon, 13 Oct 2008 19:47:44 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131947.44992.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

could somebody explain what determines when in the sequence of hot
unplugging pci_disable_device() is called?

	Regards
		Oliver
