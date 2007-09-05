Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbXIENPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbXIENPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXIENPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:15:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44363 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXIENPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:15:44 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rescanning SCSI/SATA bus
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr>
Date: Wed, 05 Sep 2007 09:15:35 -0400
In-Reply-To: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Wed, 5 Sep 2007 11:41:39 +0200 (CEST)")
Message-ID: <yq1zm01l0co.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Engelhardt <jengelh@computergmbh.de> writes:

Jan> 11:40 sun:../scsi_host/host0 # echo 1 >scan 
Jan> -bash: echo: write error: Invalid argument

Jan> What is the proper way to trigger a rescan, if it comes to be
Jan> necessary?

echo "- - -" > scan

-- 
Martin K. Petersen	Oracle Linux Engineering

