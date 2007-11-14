Return-Path: <linux-kernel-owner+w=401wt.eu-S1765024AbXKNXyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765024AbXKNXyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXKNXyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:54:43 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:55229 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbXKNXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:54:42 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: question on odd APIC behavior
Date: Thu, 15 Nov 2007 00:54:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711150054.34312.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there a way to so misprogramm an APIC that a physical interrupt results
in two interrupts delivered?

	Regards
		Oliver
