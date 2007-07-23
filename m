Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbXGWQBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbXGWQBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXGWQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:00:53 -0400
Received: from mout0.freenet.de ([195.4.92.90]:44900 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXGWQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:00:52 -0400
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: where is the code for read system call?
Date: Mon, 23 Jul 2007 18:01:32 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com> <200707210208.44698.fzu@wemgehoertderstaat.de> <A3258B497F1C1441AD36A2E8B45FD62858D1FD@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858D1FD@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707231801.32334.fzu@wemgehoertderstaat.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. Juli 2007 schrieb Agarwal, Lomesh:
> For future how do I trace a system call to a function in a kernel?

strace. i.e:
	$ strace ls
