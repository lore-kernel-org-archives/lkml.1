Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZBADAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZBADAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZBADAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:00:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:60241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZBADAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:00:03 -0500
Message-ID: <49851012.8070904@kernel.org>
Date: Sun, 01 Feb 2009 11:59:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: [PATCHSET] dmraid: use alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Feb 2009 02:59:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

This patchset is for dmraid-1.0.0.rc15 and NOT for kernel.  It
contains the following three patches to make dmraid use alt_size if
available.

  0001-dmraid-set-read_info-to-offset-by-default-in-read_.patch
  0002-dmraid-add-alt_size-to-dev_info.patch
  0003-dmraid-make-nv-use-alt_size-if-available.patch

Thanks.

-- 
tejun
