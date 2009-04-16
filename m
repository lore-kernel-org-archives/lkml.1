Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZDPXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZDPXu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZDPXuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:50:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:41027 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbZDPXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:x-mailer;
        b=NDaHbSUhcTS4xPYybx/kGqWJkgUWN7w9Phmn7lIv2lreVaBMOCy5RJ9DVG9ZKCycEH
         ALsIzIuT9a9kbSOiYzCOsvaZyRZnlSAx/mUV1UGF0ItC/2qx6EYWb1wC+nzYHyDd34rD
         oSuT5nW9vCsG+S/9bfiob2OXYm4/Sd7cpCesY=
Message-Id: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
From: Robert Nicholson <robert.nicholson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Does the linux kernel contain support for ATA Security feature set?
Date: Thu, 16 Apr 2009 18:49:59 -0500
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I've got an X-25M that I want to securely erase and it turns out  
on a Mac I'm not going to be able to issue the command because it  
doesn't support legacy IDE mode from what I understand. So the idea of  
a any boot CD that I could boot and run a program that can issue a  
SECURE_ERASE (SE) to the drive is only applicable to PC's.

So does the Linux kernel support the ATA security set then? or does  
it, like OSX have protective measures to stop abuse of those features.
