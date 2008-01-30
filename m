Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYA3G72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYA3G72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYA3G7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:59:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19062 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYA3G7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:59:18 -0500
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: Add support for DIF CRC
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <yq1prvk8p3f.fsf@sermon.lab.mkp.net>
	<Pine.LNX.4.64.0801292020010.14907@fbirervta.pbzchgretzou.qr>
Date: Wed, 30 Jan 2008 01:59:01 -0500
In-Reply-To: <Pine.LNX.4.64.0801292020010.14907@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Tue\, 29 Jan 2008 20\:21\:44 +0100 \(CET\)")
Message-ID: <yq18x2794ui.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Engelhardt <jengelh@computergmbh.de> writes:

Jan> 'const unsigned char *', like the rest of all code does.

Updated patch follows.


Jan> Do we already have some users for the T10DIF CRC? 

This is a runt patch given that it doesn't fit in block and SCSI.  The
remaining bits will come in through those trees.

-- 
Martin K. Petersen	Oracle Linux Engineering

