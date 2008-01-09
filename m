Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYAIECV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYAIECV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYAIECG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:02:06 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43992 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbYAIECF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:02:05 -0500
X-Greylist: delayed 1974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 23:02:04 EST
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200801090329.m093T7Op019488@turbo.physics.adelaide.edu.au>
Subject: Do SATA tape drives work?
To: linux-kernel@vger.kernel.org
Date: Wed, 9 Jan 2008 13:59:07 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

I was wondering whether anyone can shed any light on the status of SATA tape
drives.  There's very little info on the net about this at least in the
places I've checked; the only thing of any significance I've found thus far
is a note in a Bacula document dated April 2007 which states that drives
other than real SCSI units don't generally work with Bacula.

To put this into context, I'm looking at purchasing a Sony SDX470VRB SATA
AIT-1 tape drive for use with the SATA controller on an Intel DG31PR
mainboard.  The drive will be used primarily with tar/cpio.  Obvsiouly
however I only want to make the purchase if there's a reasonable chance of
it working.

I would appreciate any information you can shed on this issue.

Regards
  jonathan
