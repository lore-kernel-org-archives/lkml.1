Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbXHLQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbXHLQvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbXHLQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:51:35 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2352 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbXHLQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:51:33 -0400
Date: Sun, 12 Aug 2007 18:51:31 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Valdis.Kletnieks@vt.edu
Cc: roland <devzero@web.de>, linux-kernel@vger.kernel.org
Subject: Re: Software based ECC ?
Message-ID: <20070812165131.GG7973@vanheusden.com>
References: <000a01c7db93$c75b66c0$eeeea8c0@aldipc> <12507.1186812675@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12507.1186812675@turing-police.cc.vt.edu>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Aug 11 15:31:25 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://pdos.csail.mit.edu/papers/softecc:ddopson-meng/softecc_ddopson-meng.pdf
> > "SoftECC : A System for Software Memory Integrity Checking"
> 
> Personally, I'd recommend just shelling out the bucks for hardware ECC if
> the reliability matters.

a question and an idea: Q: is ecc guaranteed to detect all bitflips?

Idea: what about a multicore system (3 or more) that runs the same
processes on 2 cores and a third core verifying that they both do the
same? As I think it is not only ram that can become faulty.



Folkert van Heusden

-- 
MultiTail er et flexible tool for å kontrolere Logfiles og commandoer.
Med filtrer, farger, sammenføringer, forskeliger ansikter etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
