Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbZFYPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZFYPgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZFYPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:36:25 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:51761 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZFYPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:36:25 -0400
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <200906250904.57149.elendil@planet.nl>
Date: Thu, 25 Jun 2009 11:36:04 -0400
In-Reply-To: <200906250904.57149.elendil@planet.nl> (Frans Pop's message of
	"Thu, 25 Jun 2009 09:04:56 +0200")
Message-ID: <yq1tz24qqaj.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A439967.013C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Frans" == Frans Pop <elendil@planet.nl> writes:

Frans> During boot of 2.6.31-rc1 on an arm EABI system I got the
Frans> following errors: device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
Frans> initialised: dm-devel@redhat.com device-mapper: table: 254:0:
Frans> target device sda6 is misaligned device-mapper: table: 254:0:
Frans> target device sda6 is misaligned device-mapper: table: 254:1:
Frans> target device sda6 is misaligned device-mapper: table: 254:1:
Frans> target device sda6 is misaligned

Frans> Please advise and let me know what additional info is needed.

What kind of disk is this?

-- 
Martin K. Petersen	Oracle Linux Engineering

