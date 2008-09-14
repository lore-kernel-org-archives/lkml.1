Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYINQqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYINQqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYINQql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:46:41 -0400
Received: from smtpi1.ngi.it ([88.149.128.20]:34372 "EHLO smtpi1.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYINQql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:46:41 -0400
From: Fabio Coatti <cova@ferrara.linux.it>
To: linux-kernel@vger.kernel.org
Subject: hp smart array E200i kernel panic upon boot (bug 9859)
Date: Sun, 14 Sep 2008 18:46:38 +0200
User-Agent: KMail/1.9.9
Organization: FerraraLUG
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809141846.38808.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 
I'm still facing the issue described here: 
http://bugzilla.kernel.org/show_bug.cgi?id=9859

(basically, kernels newer than 2.6.23.12 fails to find root device on E200i 
scsi controllers, i.e. available on HP c-class blades BL465C )

Maybe I'm missing something, but even googling I've found no solutions or 
hint.

Can someone help me in getting out from this ? basically we are unable to 
upgrade kernels on that machines. Maybe I'm doing something incredibly wrong, 
but I can't figure out what, honestly.

Many thanks for any help.


-- 
Fabio Coatti       http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
