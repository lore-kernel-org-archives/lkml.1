Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXGWXJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXGWXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbXGWXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:08:58 -0400
Received: from [192.102.209.1] ([192.102.209.1]:16485 "EHLO
	laptopd505.fenrus.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933752AbXGWXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:08:56 -0400
Subject: Re: named pipe handling
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858D850@scsmsx412.amr.corp.intel.com>
References: <A3258B497F1C1441AD36A2E8B45FD62858D850@scsmsx412.amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jul 2007 16:01:59 -0700
Message-Id: <1185231719.2723.2.camel@laptop.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 15:59 -0700, Agarwal, Lomesh wrote:
> Can someone point me to named pipe read/write functions (when I issue
> read system call on a file handle obtained from mkfifo call which
> function ultimately handles it)?

lxr is your friend....

and how about grep ;)

fs/pipe.c would like be a good place to start


