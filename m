Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZEPSql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZEPSql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 14:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZEPSqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 14:46:32 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:35157 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZEPSqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 14:46:31 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: linux-kernel@vger.kernel.org
Subject: oops with 2.6.30-rc6 and reiserfs
Date: Sat, 16 May 2009 11:46:32 -0700
Message-ID: <87zldc9987.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i get an oops trying to boot into 2.6.30-rc6 with reiserfs as the root
partition. the root partition never gets mounted rw so there is
nothing in the logs but i took a picture of the screen on the laptop:

  http://costard.lbl.gov/~romosan/dsc05513.jpg

these are the config options i use relevant to reiserfs:

CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set

hope this helps.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
