Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXI2BEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXI2BEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXI2BDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:03:54 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:56219 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbXI2BDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:03:53 -0400
Date: Sat, 29 Sep 2007 03:03:51 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: regression in 2.6.23-rc8 - power off failed on old laptop
Message-ID: <20070929010351.GA4768@erig.dyndns.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the latest kernel does not power off my old laptop.

2.6.22 succeeded
2.6.23-rc8 failed

$ git bisect good 
Bisecting: 0 revisions left to test after this 
[626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 

Which more info is needed?

Wolfgang
