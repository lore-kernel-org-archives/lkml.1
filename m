Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbXLGXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbXLGXrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXLGXrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:47:03 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:47685 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXLGXrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:47:01 -0500
Date: Sat, 08 Dec 2007 00:46:59 +0100
Message-Id: <32463620@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ata_piix init/performance regression ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+Z9RkSsI66uI3nLVJC9C/Q7VbJf1fYYMDKe7twLxZNnK65m
 Off33Ux08pEcqsAjFO+CA55/n6cYCP0u2hjjxLiLFVQNV2qqxU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

on my old fujitsu-siemens lifebook, booting is at least 20 seconds slower as before.

on ata_piix init i can see 2 longer delays of ~10 seconds each, which didn`t happen before.

i`m using SuSE kernel of the day from http://ftp.suse.com/pub/projects/kernel/kotd/

problem exists with these kernels:
kernel-vanilla-2.6.24_rc3_git3-20071201095839
kernel-default-2.6.24_rc3_git3-20071201095839
kernel-default-2.6.24_rc4_git3-20071206172629
kernel-vanilla-2.6.24_rc4_git3-20071206172629

problem didn`t exist with this one:
kernel-default-2.6.22.12-0.1 (opensuse 10.3 default)

please see https://bugzilla.novell.com/show_bug.cgi?id=345442 for more details.

regards
roland

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

