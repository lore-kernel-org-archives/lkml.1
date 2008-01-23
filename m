Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYAWEdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYAWEdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYAWEd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:33:29 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:47894 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795AbYAWEd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:33:28 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200801230430.m0N4UmpU029430@turbo.physics.adelaide.edu.au>
Subject: XFS oops under 2.6.23.9
To: linux-kernel@vger.kernel.org
Date: Wed, 23 Jan 2008 15:00:48 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last night my laptop suffered an oops during closedown.  The full oops
reports can be downloaded from

  http://www.atrad.com.au/~jwoithe/xfs_oops/

as photos of the screen.  Since the laptop was unusable at this point I
wasn't able to cut and paste the details, and they weren't in the logs when
the machine was rebooted.

The initial complaint claims to be an "invalid opcode".  Is this possibly a
memory fault developing or does it ring any bells for anyone?  memtest86
finds no fault with the memory.

Kernel version was kernel.org 2.6.23.9 compiled as a low latency desktop. 
The RT patches were not applied.

Regards
  jonathan
