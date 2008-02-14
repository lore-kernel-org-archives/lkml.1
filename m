Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbYBNWPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbYBNWPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764483AbYBNWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:15:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:10764 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYBNWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iCJzgThhsDY7B0Zrm3NlUbD+qRlaTutr3lRsMmIfWk2ygYLYE49W9LmdaCHdgTsrjB6PZkeQBtxx57Y8ZXSP4ru+tK/cpcZ8HCwU3hjbr123qucuS7u5EUhQYgcU7Z8huBRZR7cmZ8M3ep4tMRoLq90N+qg3GdOEJgMLfG+PH1w=
Message-ID: <934f64a20802141415o6d2aee9au187a3d3afb15cd53@mail.gmail.com>
Date: Thu, 14 Feb 2008 16:15:41 -0600
From: "David Nicol" <davidnicol@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: warning with 2.6.24.2 linking
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we care?


  AS      .tmp_kallsyms2.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xe51ac): Section mismatch: reference to
.init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and
'pci_scan_bus_parented')
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map


-- 
"The ultraleft underground armed revolutionary groups that burned down
our offices and forced our staff to leave the villages at gunpoint now
disappeared. We could finally concentrate on the production of fish."
-- Mohammad Yunus
