Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZISVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZISVqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZISVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:46:35 -0400
Received: from mx.amg.net.pl ([91.193.144.104]:55692 "EHLO mx.amg.net.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbZISVqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:46:33 -0400
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 17:46:33 EDT
From: Arkadiusz Patyk <areq@areq.eu.org>
To: linux-kernel@vger.kernel.org
Subject: De-duplication filesystem for Linux
Date: Sat, 19 Sep 2009 23:19:09 +0200
Message-ID: <feiab5lup017ddnbltttpmip04lhh5j519@4ax.com>
X-Mailer: Forte Agent 5.00/32.1170
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Is there other working fs with data de-duplication than  lessfs ?

http://freshmeat.net/projects/lessfs
http://www.lessfs.com/

Lessfs is a high performance inline data deduplicating file system for
Linux. Lessfs complies to the POSIX standard and is very useful for
backup purposes as well as providing storage for virtual machine
images. Although lessfs is a file system that is implemented in user
space with FUSE, it offers decent performance. Lessfs is capable of
handling data rates up to 350MB/sec. It supports filesystem
encryption.

Cheers,
-- 
Arkadiusz Patyk [areq<>pld-linux:org] [http://rescuecd.pld-linux.org/]
[IRC:areq GG:1383 jid:arek<>patyk:net]
