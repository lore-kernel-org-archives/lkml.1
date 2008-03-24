Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYCXC1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYCXC1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 22:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYCXC1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 22:27:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYCXC1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:27:31 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 1/8] ide: always auto-tune PIO in legacy VLB host drivers
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 24 Mar 2008 03:27:22 +0100
References: <aajV7-54-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JdcPD-0000lP-2t@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19cNTvxFMoPkrnYzLokkHfbaW9AJFJ93o4sjeW
 KfpvLSCpK0Dd2bKRuC7qjbEA/8i1sTAqb7hKsoTKq3W/JATN+h
 CV/O3eKsSjJM8fQnkF5Cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

|Subject: [PATCH 1/8] ide: always auto-tune PIO in legacy VLB host drivers

AFAIR this isn't safe for bus speeds above 33 MHz, is it?

