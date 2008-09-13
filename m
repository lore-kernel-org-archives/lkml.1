Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYIMGdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYIMGdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 02:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYIMGc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 02:32:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31032 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYIMGc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 02:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=L4WjvKeU1+2WPG73kk0/ZVpGmB57PAp+TY5QIPhB3Uw8N54DsaoJveLbtuNOPjyo62
         nXKP9XqjdmPGLDOpzuol4/Jk7d+wVEoryD2D9/CWjMPt3r26sy8D1QqEPnACRenq597v
         aX7rnEMFZvox1tKdKu3uvued831HvKobVriHM=
Message-ID: <48CB5E95.4000208@gmail.com>
Date: Fri, 12 Sep 2008 23:32:53 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [MTD] physmap.c: Minor cleanups
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are all quite minor (pretty trivial, actually), but address
different things physmap.c, so I've sent sent them as a patch set rather than as a
single patch.

The diffstat:
  drivers/mtd/maps/physmap.c |   13 +++++++++----
  1 files changed, 9 insertions(+), 4 deletions(-)


Thanks,
Zev Weiss


