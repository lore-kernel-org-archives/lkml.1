Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXKMMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXKMMLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXKMMLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:11:04 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:12591 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752695AbXKMMLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:11:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZI6M6yxq/zO033/G5TNVerbb/ENIvwbIL1KWVNkDdIxP/r3HuCJVTAffzvjpPiDFLAaWz9uegtRGDsc4xCH/RfGmBbpwem8lzZJtjLkXlfgi0zpSbtiTNMB/wbuWj+ZAWMu5yCjs1uJf2Ggw3t7vzRueLMrv8nYxB40uBdlt3Qw=
Message-ID: <e85b9d30711130411s5dd20b9t2e407d9617a36c65@mail.gmail.com>
Date: Tue, 13 Nov 2007 13:11:00 +0100
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: git changelog / shortlog function on www.eu.kernel.org still refers to www.kernel.org server
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody on the linux-kernel mailing list,

I discovered that the changelog-function of www.eu.kernel.org still
links / refers to www.kernel.org

e.g. if I click on:

The latest stable version of the Linux kernel is:  	2.6.23.1
	2007-10-12 16:47 UTC 	F 	V 	  	C 	Changelog <== on the 'C'

it refers to http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.23.y.git;a=summary

shouldn't the link better refer on each 'C' to
http://git.eu.kernel.org/?p=linux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.23.y.git;a=summary
(http://git.eu.kernel.org)

that should put less load on the general / US-servers  ...

... or am I wrong and it is handled via round-robin ?

hope everyone understands what I mean ;)

Cheers

Mat
