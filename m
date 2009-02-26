Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZBZSWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZBZSWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBZSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:22:09 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:56394 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZBZSWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:22:07 -0500
Message-ID: <49A6DDC8.4080304@pobox.com>
Date: Thu, 26 Feb 2009 13:22:00 -0500
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: hdparm-9.12 released
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
In-Reply-To: <1235600698-6446-1-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 88B2042C-04FB-11DE-9E13-8D02133F2F75-82205200!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdparm-9.12 is now available for download from sourceforge.net.

Changes from 9.11 include:
   - added logical/physical sector size reporting
   - updated -I output with SATA-2.6 additions
   - support APM level retrieval with -B flag
   - updated -C output to match ATA8
   - added "form factor" and "rotation" display to -I,
          courtesy of Martin K.Petersen.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
